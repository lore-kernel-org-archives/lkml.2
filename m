Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1ACOfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:35:21 -0500
Received: from smtp.fullrate.dk ([90.185.1.42]:55898 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1ACOfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:35:20 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 09:35:20 EST
Date: Mon, 3 Jan 2011 15:25:25 +0100 (CET)
From: Martin Nybo Andersen <tweek@tweek.dk>
To: Tom Watson <tsw@johana.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Offset into block file for mounting?
In-Reply-To: <1294060384.3030.18.camel@xytar7a>
Message-ID: <alpine.DEB.2.00.1101031518410.12757@odin.tweek.dk>
References: <1294060384.3030.18.camel@xytar7a>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Mon, 3 Jan 2011, Tom Watson wrote:

> Hi...
>
> I recently got a "floppy drive emulator" that uses an USB thumb drive to
> emulate floppy images to be used as a floppy drive.  In trying out the
> software (it is a bit cryptic), I found that this model stores the
> floppy images consecutively on said thumb drive (with some padding to
> make the drives on 1.5 Mbyte borders on the thumb drive.  When plugging
> in the thumb drive, the 'vfat' module just mounts the first image (as I
> expect).  What I would like to do is mount some of the other images that
> exist (I dumped out the raw thumb drive).  I believe that a simple way
> to do this is to add an offset to the vfat mount, so that the accesses
> begin at (as in my example) 0x180000 (and multiples thereof) from the
> start of the physical drive.
>
> Is there any way to add such an offset?
> Would it be useful in any other file systems?

mount diskimage /dir -t vfat -o loop,offset=xxx,sizelimit=yyy

mount will then forward the offset and sizelimit options to losetup which 
sets up a loop device before mounting.

Have a look at the man-pages for mount and losetup. :-)

Hope that helps.

> [...]
> -- 
> Tom Watson <tsw@johana.com>
> I'm at home now

-- 
Martin
