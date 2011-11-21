Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1KUIZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:25:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1KUIZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:25:23 -0500
Date: Mon, 21 Nov 2011 09:25:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the Linus' tree
In-Reply-To: <20111121131701.44b49fc7da28170c9ee6b524@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1111210922090.10414@axis700.grange>
References: <20111121131701.44b49fc7da28170c9ee6b524@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:qZbiRjy58qq3xaT0bBAHTL1TUrCHz7OFWbAz75tI6u8
 HCAxgFdBwax7p/TX0rpx3CKse3Y5nvcwuyYPc7tUSIDWro97rt
 aMBPrQC/g2Dy6KtNig5jOedWu6f+1Dfk79kkxgwcrlF4W+ghUl
 +oxRPi49LLr4wwUggYNw3MOnygtG74pmqEZZ6yWYHrf+jbgvnF
 SZevG8VD+36CW4vvBM50RotKQXMZH+u1faCnHNexJ99L9D91ns
 amHjGaBefoVOiwbJSrFBuF1nyklmg6z//6jGzsQgVl+Wzg6DE8
 NIRRZlyzK8FzCX8odvC7qV9xuCg8gdcuzc6j2JKdAg4UjkU4yJ
 WDqV/Yp/Qx7tczG8GOICmaNX55dUzzQMthIDrMJV3nFSYh3aId
 +hsJpFPVaCekQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen

On Mon, 21 Nov 2011, Stephen Rothwell wrote:

> Hi all,
> 
> Building Linus' tree today linux-next (x86_64_allmodconfig)
> produced quite a few of these warnings:
> 
> include/media/soc_camera.h: In function 'soc_camera_i2c_to_vdev':
> include/media/soc_camera.h:257:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> 
> This was introduced by commit 2f0babb7e432 ("[media] V4L: soc-camera:
> make (almost) all client drivers re-usable outside of the framework").
> 
> This warning is caused by the "grp_id" member of "struct v4l2_subdev" -
> which is a u32 - being cast to a pointer.  That pointer is dereferenced,
> so I have no idea how that is supposed to work on any 64 bit platform.

soc-camera atm supports 7 platforms (if I haven't forgotten anyone), none 
of them is 64-bit. But you're right, it shall compile cleanly on 64 bits 
too, I'm working on a patch. Unfortunately, while working on it I came 
across other regressions, that blocked my tests... But a solution will be 
found.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
