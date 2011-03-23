Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab1CWPFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:05:51 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:45315 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932945Ab1CWPFt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:05:49 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Greg KH <gregkh@suse.de>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Date: Wed, 23 Mar 2011 16:05:13 +0100
Subject: RE: [PATCH 1/2] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH 1/2] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcvpZugE1BNN8iNTTeurGHZ8QTT6XwAAKn9Q
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C4DE875@EXDCVYMBSTM005.EQ1STM.local>
References: <1300888771-26437-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110323143144.GB17369@suse.de>
In-Reply-To: <20110323143144.GB17369@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for your comments.

> > +
> > + - Decide upon architecture. Some people consider architecture in
> the cg2900
> > +   driver to be too complex. We consider it to be not more complex
> than needed.
> 
> What do you mean by this?  It sounds as if you do not consider this a
> valid thing.  If so, why list it?
> 

I've been trying to get this driver into the "normal" driver tree
(Bluetooth and mfd) for the past half year. We have at this point
come to such a standstill that we wanted to get the driver into staging
where we could then continue the architecture discussion.

> > + - Currently the cg2900_uart registers as protocol driver against
> hci_ldisc.c.
> > +   There is however some common functionality with hci_h4.c and the
> cg2900 could
> > +   therefore register it's vendor specific channels to hci_h4.c, but
> this would
> > +   require adding a registration functionality in the hci_h4 file.
> 
> Putting a "but" makes it sound like this is something you will not do.
> If so, why list it?
> 

Again, this is due to discussions and putting the driver in staging
will make it easier to get a view of the driver. Making such a change
would also quite heavily affect the Bluetooth driver.

> > + - Some people demand that the cg2900 driver re-use the Bluetooth
> driver to send
> > +   and receive BT commands and events. That is however not possible
> with current
> > +   BT API and might not be feasible, for example when using FM only
> in
> > +   the cg2900 chip.
> 
> Again, a review comment that you are saying is not valid.  Why list it?
> 

And, again, it was blocking us from getting the driver into the Kernel.
So we have to solve the issue in some way, but it is not clear at this
point exactly how it will be solved (and therefore also not where it
will be solved).

> > + - TI has already delivered a driver for a multi-function chip
> called ti-st.
> > +   This driver is currently located in drivers/misc/ti-st/. There
> has however
> > +   been criticism raised against design/architecture of the driver.
> There
> > +   currently also doesn't seem to be a way to add support for cg2900
> in that
> > +   driver even though some people has raised this as an alternative.
> 
> And again, the same thing.
> 
> What criticism of that driver?  It's now accepted and is working and in
> the tree.
> 

I will remove this text. There was criticism against the driver in the
mail discussions, but I agree that it should not be stated in this TODO
file.

> My main point here is that this looks like a rant against people who
> have reviewed your code in the past and why you feel you can not
> address
> those complaints.  That's not a valid thing for a TODO file at all.
> Please list things that need to be fixed in the driver to get it merged
> into the main tree.  As it is, you have a list of things that you say
> you will not do, which is not encouraging at all.
> 

I'm sorry if it sounds like a rant against people who've reviewed the code.
That was never my intention.
I will see if I can rephrase, but the problem is that nothing has still been
decided so at this point it is hard to say exactly what shall be fixed.
But as I said, I will try to rewrite it in a better way.

> > diff --git a/drivers/staging/cg2900/bluetooth/Makefile
> b/drivers/staging/cg2900/bluetooth/Makefile
> > new file mode 100644
> > index 0000000..6f4255b
> > --- /dev/null
> > +++ b/drivers/staging/cg2900/bluetooth/Makefile
> > @@ -0,0 +1,9 @@
> > +#
> > +# Makefile for ST-Ericsson CG2900 connectivity combo controller
> > +#
> > +
> > +ccflags-y :=					\
> > +	-Idrivers/staging/cg2900/include
> > +
> 
> Trailing whitespace, did you run this through checkpatch.pl before
> sending it to me?
> 
> thanks,
> 
> greg k-h

I will fix and make certain that I haven't missed anything more.
I have run checkpatch but in the hurry I must have made a last
minute change and forgot to run checkpatch on the last patch version.

/P-G
