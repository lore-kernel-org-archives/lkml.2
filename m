Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1DTNnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:43:49 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:14385
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983Ab1DTNnq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:43:46 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1803M9371O148cM542M1432Nzz1202hzz8275dhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] tty/serial: add support for Xilinx PS UART
Date: Wed, 20 Apr 2011 07:43:29 -0600
In-Reply-To: <20110420102501.1e395f14@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] tty/serial: add support for Xilinx PS UART
Thread-Index: Acv/PLPOl8sNLEFuS8uTsbXQH/yfoQAI/x0A
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local><20110419221530.7370d013@lxorguk.ukuu.org.uk><551928f1-72b8-432e-879e-8721b5c87414@VA3EHSMHS017.ehs.local> <20110420102501.1e395f14@lxorguk.ukuu.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
X-OriginalArrivalTime: 20 Apr 2011 13:43:36.0141 (UTC) FILETIME=[F28C37D0:01CBFF60]
X-RCIS-Action: ALLOW
Message-ID: <b744d309-dbb5-44d4-9d51-98e50970c2a2@VA3EHSMHS018.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Wednesday, April 20, 2011 3:25 AM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
> 
> > > > +	/* Min baud rate = 6bps and Max Baud Rate is 10Mbps for
> 100Mhz
> > > clk */
> > > > +	baud = uart_get_baud_rate(port, termios, old, 0,
460800);
> > > > +	xuartps_set_baud_rate(port, baud);
> > >
> > > So why pass 460800 ?
> >
> > Seems like 115200 is better number.
> 
> Well if it can do 10Mbit why not pass 10Mbit as the upper limit ?

The only reason would be because we don't test it, but yes that could be
done.

> 
> > > And set the baud rate (see 8250.c for an example). Note that the
> > helper
> > > functions know about mapping slight errors so if you are asked for
> > 9600
> > > and the hardware does 9575 it will report B9600 as you'd expect
not
> do
> > > something crazy.
> > >
> >
> > Sorry I didn't follow what you meant above. The h/w is a bit
> different
> > with it's
> > baud rate settings due to 2 different dividers.
> 
> After you've worked out what baud rate you actually set do
> 
> 	       /* Don't rewrite B0 */
>         if (tty_termios_baud_rate(termios))
>                 tty_termios_encode_baud_rate(termios, baud, baud);
> 
> 
> which will ensure that the termios reflects the actual rate.

Thanks for clarifying, I'll look at that.

-- John

> 
> Alan


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


