Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1DSXjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:39:46 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:12959
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab1DSXjo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:39:44 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1803M9371O542M1432N98dK4015Lzz1202hzz8275bh8275dhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] tty/serial: add support for Xilinx PS UART
Date: Tue, 19 Apr 2011 17:39:30 -0600
In-Reply-To: <20110419232141.GA27491@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] tty/serial: add support for Xilinx PS UART
Thread-Index: Acv+6KDmIk5chGFMQa+qju79mH+T9gAAPlaw
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local> <20110419221530.7370d013@lxorguk.ukuu.org.uk> <8d05c32c-9ff1-4eda-9563-6857ede6541a@VA3EHSMHS020.ehs.local> <20110419232141.GA27491@kroah.com>
From: John Linn <John.Linn@xilinx.com>
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
X-OriginalArrivalTime: 19 Apr 2011 23:39:24.0652 (UTC) FILETIME=[03E85AC0:01CBFEEB]
X-RCIS-Action: ALLOW
Message-ID: <68925dd6-03b8-48af-9f96-0a3f611712e1@VA3EHSMHS020.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 19, 2011 5:22 PM
> To: John Linn
> Cc: Alan Cox; linux-kernel@vger.kernel.org; linux-
> serial@vger.kernel.org
> Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
> 
> On Tue, Apr 19, 2011 at 04:22:00PM -0600, John Linn wrote:
> > > -----Original Message-----
> > > From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> > > Sent: Tuesday, April 19, 2011 3:16 PM
> > > To: John Linn
> > > Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> > > Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
> > >
> > > On Tue, 19 Apr 2011 14:14:52 -0600
> > > John Linn <john.linn@xilinx.com> wrote:
> > >
> > > > The Xilinx PS Uart is used on the new ARM based SoC. This
> > > > UART is not compatible with others such that a seperate
> > > > driver is required.
> > >
> > > Joyous. I wish people would standardise.
> > >
> > > > +		 213 = /dev/ttyPS0		Xilinx PS serial
port 0
> > > > +		 214 = /dev/ttyPS1		Xilinx PS serial
port 1
> > > > +		 215 = /dev/ttyPS2		Xilinx PS serial
port 2
> > > > +		 216 = /dev/ttyPS3		Xilinx PS serial
port 3
> > >
> > > Is there a specific reason you need fixed minor numbers ? If not
> > please
> > > use a dynamic range and keep Linus happy.
> >
> > Hi Alan,
> >
> > I hope you don't mind me asking a bit more to better understand.
> Here's
> > my
> > concerns (maybe not valid).
> >
> > It seems like since this is a console it can get hard to debug with
> > dynamic
> > nodes for this driver.
> >
> > This driver is for an embedded device where we don't want to require
> > udev
> > or mdev to assign nodes.
> 
> Why not use devtmpfs?  There's no need to use udev or mdev at all.
> 

Hi Greg,

Reading up on it a bit as I'm not an expert on it (like you). 
It's not clear to me what the device driver uses for it's major/minor in
this case.  

Maybe it doesn't matter, the driver can use ttyS0 and then it gets
deleted 
later if you want to change it.

The only reason we didn't just use ttyS0 was that it's not a 8250 really
and
since we have are an FPGA people can add real 8250s in soft logic and
then
the system would get confusing.

Thanks,
John

> thanks,
> 
> greg k-h


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


