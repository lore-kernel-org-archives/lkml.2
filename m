Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1AJUN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:13:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50829 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJUN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:13:28 -0500
From: "Igor M. Liplianin" <liplianin@me.by>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
Date: Mon, 10 Jan 2011 22:10:37 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.37-smp+; KDE/4.4.3; i686; ; )
Cc: Ben Gamari <bgamari.foss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        aospan@netup.ru
References: <201012310726.31851.liplianin@netup.ru> <8739pec7bm.fsf@gmail.com> <201101051126.04180.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101051126.04180.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101102210.37513.liplianin@me.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от 5 января 2011 12:26:03 автор Laurent Pinchart написал:
> Hi,
> 
> On Friday 31 December 2010 16:04:13 Ben Gamari wrote:
> > On Fri, 31 Dec 2010 09:47:41 -0200, Mauro Carvalho Chehab wrote:
> > > > I understand this. However, a complete JTAG state machine in the
> > > > kernel, plus an Altera firmware parser, seems to be a lot of code
> > > > that could live in userspace.
> > > 
> > > Moving it to userspace would mean a kernel driver that would depend on
> > > an userspace daemon^Wfirmware loader to work. I would NAK such
> > > designs.
> > 
> > Why? I agree that JTAG is a lot to place in the kernel and is much
> > better suited to be in user space. What exactly is your objection to
> > depending on a userspace utility? There is no shortage of precedent for
> > loading firmware in userspace (e.g. fx2 usb devices).
> 
> I agree with this. Mauro, why would a userspace firmware loader be such a
> bad idea ?
> 
> > > > If I understand it correctly the driver assumes the firmware is in an
> > > > Altera proprietary format. If we really want JTAG code in the kernel
> > > > we should at least split the file parser and the TAP access code.
> > > 
> > > Agreed, but I don't think this would be a good reason to block the code
> > > merge for .38.
> > 
> > I agree with the above isn't good reason to block it but if there is
> > still debate about the general architecture of the code (see above),
> > then it seems aren't ready yet. The code looks very nice, but I'm not at
> > all convinced that it needs to be in the kernel. Just my two-tenths of a
> > cent.
We all realize, that FPGA programming not belongs to DVB only, it is more common.
But my intention to write driver for DVB and V4L device... 
Yes, it needed for DVB device to work, and it works on real hardware.
FPGA model used in device has not flash memory. So every time the so-called "firmware" has to be 
loaded on early device initialization stage. Then FPGA itself drives CI and hardware PID filter. 
Fhysically, FPGA JTAG interface connected to cx23885 GPIO lines.

Take a look on  media/dvb/dvb-usb drivers. There is a lot of FX2 firmware dependant devices, but 
no one of them uses userspace utilities to push firmware inside.
If someone has something to put on table, I mean code implementation, then put it on.

Everithing is possible to change, but it is needed to begin with something.
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
