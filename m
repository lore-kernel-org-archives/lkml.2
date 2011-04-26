Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1DZIad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:30:33 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:36525 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123Ab1DZIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:30:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
Date: Tue, 26 Apr 2011 10:30:21 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201104252323.20420.linux@rainbow-software.org> <201104260832.11150.hverkuil@xs4all.nl>
In-Reply-To: <201104260832.11150.hverkuil@xs4all.nl>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104261030.21681.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 April 2011, you wrote:
> On Monday, April 25, 2011 23:23:17 Ondrej Zary wrote:
> > The YVU420 and YUV422P formats are broken and cause kernel panic on use.
> > (YVU420 does not work and sometimes causes "unable to handle paging
> > request" panic, YUV422P always causes "NULL pointer dereference").
> >
> > As V4L2 spec says that drivers shouldn't do any in-kernel image format
> > conversion, remove it completely (except YUYV).
>
> What really should happen is that the conversion is moved to libv4lconvert.
> I've never had the time to tackle that, but it would improve this driver a
> lot.

Depending on isoc_mode module parameter, the device uses different image 
formats: YUV 4:2:2 interleaved, YUV 4:2:0 planar or compressed format.

Maybe the parameter should go away and these three formats exposed to 
userspace? Hopefully the non-compressed formats could be used directly 
without any conversion. But the compressed format (with new V4L2_PIX_FMT_ 
assigned?) should be preferred (as it provides much higher frame rates). The 
code moved into libv4lconvert would decompress the format and convert into 
something standard (YUV420?).

> Would you perhaps be interested in doing that work?

I can try it. But the hardware isn't mine so my time is limited.

> > The removal also reveals an off-by-one bug in enum_fmt ioctl - it misses
> > the last format, so this patch fixes it too.
>
> Good. But why are the GREY/RGB formats also removed? Are those broken as
> well?

GREY, RGB24 and RGB32 seem to work (at least with mplayer). RGB565 and RGB555 
have wrong colors. GREY is implemented only in compressed mode but can be 
selected in other modes too. Can't userspace do the conversion better?

> Regards,
>
> 	Hans

-- 
Ondrej Zary
