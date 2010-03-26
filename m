Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CZQN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:13:27 -0400
Received: from web94910.mail.in2.yahoo.com ([203.104.17.172]:48460 "HELO
	web94910.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751716Ab0CZQNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:13:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=FmYQBZv0B6kIpOZEWn052FheoPmj+yAcQdfgKKZ+MwDdDyJeF3pzoBzk6h3i9OXRqBBFi/xxCEwHUY9w9fvKQCxucdtbqFQZH3iYZe5FQ1rOkdni1iXESW3m44CPdmF7xm81WK5Oo92AdpPsLC65XjlGzg/SD0mv+XC71a0QEBY=;
Message-ID: <911285.11966.qm@web94910.mail.in2.yahoo.com>
X-YMail-OSG: nuezTTgVM1ntsdSV1XDPuDv3FuLPGGw7hxVbO8XC1zEeXzm
 w.BlopnZ7kGx7CZ6UWbwWwkiSA52.LFW8zxpj156ZZyxjLDNNzMrmtxYRs2N
 1TtqTB3kFuEBS_r.pnLeQpT72TqimIOF3OiJvVp0byJPD4jO5umf99rJJxrY
 vkQUHB5LRUN_WuhOAkqRh.QryB1cIhsitMF5XabaRzw7ELNwT5QhWKxqIgm_
 7wWd2A.xbZoqYDnKdpVlJwaYtNuoL1qwGexs1oz2TzLHAxCwAUPlgDq4PUMU
 FFO0dgQk0Z3yGrWy3KA--
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Fri, 26 Mar 2010 21:43:19 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH] rfkill: core: add custom rfkill switch
To: Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100326065803.GD26602@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 26/3/10, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Subject: Re: [PATCH] rfkill: core: add custom rfkill switch
> To: "Johannes Berg" <johannes@sipsolutions.net>
> Cc: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Date: Friday, 26 March, 2010, 12:28 PM
> On Thu, Mar 25, 2010 at 11:39:10PM
> -0700, Johannes Berg wrote:
> > On Thu, 2010-03-25 at 23:23 -0700, Dmitry Torokhov
> wrote:
> > 
> > > > I do have an actual driver it's just that
> all 3 cores are controlled
> > > > by 1 chip_enable and individual cores are
> powered up down by s/w
> > > > commands.
> > > > 
> > > 
> > > Hmm, so the main portion of the driver needs to
> count the number of
> > > active users across rfkill interfaces 
> before powering down the chip. I
> > > do not quite understand what the issue is
> here...
> > 
> > He also wants to (ab)use rfkill to signal to userspace
> what the value of
> > that counter is ...
> > 
> 
> Well, this one is easy - just say 'No' ;)
> 
> -- 
> Dmitry

Well, Almost, I don't want to signal the user-space about the counter.
Have a look @ http://lkml.org/lkml/2010/3/24/303

See the kernel space (bluetooth driver) would register itself, to my line discipline driver, when someone does a 'hciconfig hci0 up' which is essentially BT-On.

So, now from my ldisc driver (which intends to mux BT/FM and GPS over UART), I need to signal a user-space daemon to open the TTY device, set the baud rate and install the ldisc - So I can make use of it.

To notify that user-space daemon, I had planned to use /dev/rfkill.
However, now with BT application also toggling the rfkill switch by writing to sysfs entry - is causing a bit of confusion to my user-space daemon.

Although I now use hard/soft members of struct rfkill_event now to differentiate the 2 events (1 auto generated, another from BT app) - This patch would make it a bit more proper.




      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
