Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2AYJdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:33:00 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:30052 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754164Ab2AYJcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:32:52 -0500
thread-index: AczbREeuoIYMFryaQ5yf26doujZ+1w==
Thread-Topic: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet driver to blame? Yep
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "RT" <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet driver to blame? Yep
Date: Wed, 25 Jan 2012 10:31:48 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "Mike Galbraith" <efault@gmx.de>,
        "Tim Sander" <tstone@iss.tu-darmstadt.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Clark Williams" <williams@redhat.com>,
        "John Kacur" <jkacur@redhat.com>,
        "Gerlando Falauto" <gerlando.falauto@keymile.com>,
        "Micha Nelissen" <micha@neli.hopto.org>,
        "Holger Brunck" <holger.brunck@keymile.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <201201181211.45011.tim.sander@hbm.com> <201201241152.21472.tim.sander@hbm.com>
In-reply-to: <201201241152.21472.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201201251031.48983.tim.sander@hbm.com>
X-OriginalArrivalTime: 25 Jan 2012 09:32:39.0209 (UTC) FILETIME=[4794B990:01CCDB44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > Well thanks for your patch. It didn't apply cleanly due to some moved
> > lines, but nothing to serious. I now have a machine where top just shows
> > me the culprit:
> > sirq-net-tx/0
> > 
> > It seems to be triggered not as often as the mainline rt kernel though.
> > But after some starts and stops of "connmand" and "ifconfig eth0 down" i
> > got back this errornous behaviour. The only question is what next? Still
> > i have some more observations which might help to nail down this bug: *
> > ifconfig does not return when sirq-net-tx/0 eats all cpu
> > * sometimes sirq-net-tx/0 sits on the cpu for a couple of seconds and
> > goes away, somtimes it just stays there when "ifconfig eth0 up" is
> > issued. * There are suspicious "FEC: MDIO read timeout" kernel log
> > messages from the ethernet driver.
> > * The ethernet phy uses polling since i do not know how to set the phy
> > irq in the board definition. I tried using "phy_register_fixup_for_uid"
> > and then setting the phy_dev->irq int the fixup routine but that seems
> > to be to late and the interrupt is deregisterd but has not been
> > registered when the network device is shut down.
> > I also didn't found a example in the source and there has been no word in
> > the phy.txt documentation about it? So input on how to set the phy irq in
> > the board config of the pcm043 would be really nice.
> 
> I would like to point out that the running wild softirq seems to bee fixed
> by 9ec14c04ec6be93ff397adf250bc91ee77742bfb of the stable git tree.
> At least i could not reproduce the ksoftirq error with 3.0.17-rt33. With
> the above commit reverted i could reproduce this error. As this running
> wild ksoftirq did not occur regularly there is a small chance that this
> error just didn't show up with the new kernel but i doubt it.

Bad news, the ksoftirq(sirq-net-tx) error seems to happen not so often any 
more but it still happens :-(.

So any input on that is highly apreciated.
Tim

Please ignore:



Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
