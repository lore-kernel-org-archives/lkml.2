Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2K1MS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:18:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab2K1MSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:18:25 -0500
Date: Wed, 28 Nov 2012 10:18:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        "Sakari Ailus" <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Message-ID: <20121128101802.0eafb6e7@redhat.com>
In-Reply-To: <201211281256.10839.hansverk@cisco.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
	<20121128114537.GN11248@mwanda>
	<201211281256.10839.hansverk@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 28 Nov 2012 12:56:10 +0100
Hans Verkuil <hansverk@cisco.com> escreveu:

> On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
> > I wish people wouldn't submit big patches right before the merge
> > window opens...  :/ It's better to let it sit in linux-next for a
> > couple weeks so people can mess with it a bit.
> 
> It's been under review for quite some time now, and the main change since
> the last posted version is that this is now moved to staging/media.
> 
> So it is not yet ready for prime time, but we do want it in to simplify
> the last remaining improvements needed to move it to drivers/media.

"last remaining improvements"? I didn't review the patchset, but
the TODO list seems to have several pending stuff there:

+- User space interface refinement
+        - Controls should be used when possible rather than private ioctl
+        - No enums should be used
+        - Use of MC and V4L2 subdev APIs when applicable
+        - Single interface header might suffice
+        - Current interface forces to configure everything at once
+- Get rid of the dm365_ipipe_hw.[ch] layer
+- Active external sub-devices defined by link configuration; no strcmp
+  needed
+- More generic platform data (i2c adapters)
+- The driver should have no knowledge of possible external subdevs; see
+  struct vpfe_subdev_id
+- Some of the hardware control should be refactorede
+- Check proper serialisation (through mutexes and spinlocks)
+- Names that are visible in kernel global namespace should have a common
+  prefix (or a few)

>From the above comments, both Kernelspace and Userspace APIs require 
lots of work.

Also, it is not clear at all if this is a fork of the existing davinci
driver, or if it is a completely new driver for an already-supported
hardware, making very hard (if not impossible) to review it, and, if it
is yet-another-driver for the same hardware, moving it out of staging
will be a big issue, as it won't be trivial to check for regressions
introduced by a different driver.

> 
> I'm happy with this going in given the circumstances.

Well, I'm not.

-- 
Regards,
Mauro
