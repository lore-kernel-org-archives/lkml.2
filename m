Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2EBMXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:23:49 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:33636 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2EBMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:23:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: UVCvideo:  Failed to resubmit video URB (-27) with Linux 3.3.3
Date: Wed, 02 May 2012 14:24:11 +0200
Message-ID: <1682934.ZponbpoO2x@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.1; x86_64; ; )
In-Reply-To: <20120426200721.0c3ca642@destiny.ordissimo>
References: <20120426200721.0c3ca642@destiny.ordissimo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anisse,

On Thursday 26 April 2012 20:07:21 Anisse Astier wrote:
> Hi,
> 
> I'm experiencing a problem with uvcvideo with kernel 3.3.3 and today's
> Linus' tree.
> 
> Problem not reproduced in 3.2.15, so this could be labelled as a regression.
> 
> See webcam lsusb and (verbose!) dmesg log in attachment, which exhibits
> the problem.
> 
> We see lots of error (-18 = -EXDEV), that indicate that URB was too late
> and then dropped, and they add up until we reach the "Failed to resubmit
> video URB" scheduling issue.

Those are USB controller issues. The uvcvideo driver submits URBs with the 
URB_ISO_ASAP transfer flag, so the controller should not fail to schedule 
them.

> Installed libv4l version is 0.8.6.
> I'm reproducing this with: gst-launch-0.10 --verbose v4l2src  ! xvimagesink
> (Skype exhibits the problem too, while it isn't using gstreamer, so it
> really seems to come from kernel. Also, doesn't happen with 3.2)
> 
> This is the first part of the problem. The second part is that if I
> restart the webcam with gst-launch after the first failure, I have a
> total freeze, just after these messages in the log (fetched with
> netconsole, I wasn't able to get a panic trace):
> 
> [  191.796217] uvcvideo: Marking buffer as bad (error bit set).
> [  191.796233] uvcvideo: Marking buffer as bad (error bit set).
> [  191.796244] uvcvideo: Marking buffer as bad (error bit set).
> [  191.796252] uvcvideo: Marking buffer as bad (error bit set).
> [  191.796259] uvcvideo: Frame complete (EOF found).
> [  191.796265] uvcvideo: EOF in empty payload.
> [  192.972803] uvcvideo: Marking buffer as bad (error bit set).
> [  192.972818] uvcvideo: Dropping payload (out of sync).
> [  194.289463] uvcvideo: Marking buffer as bad (error bit set).
> [  194.289478] uvcvideo: Frame complete (FID bit toggled).
> [  194.289486] uvcvideo: Marking buffer as bad (error bit set).
> [  194.289493] uvcvideo: Frame complete (FID bit toggled).
> [  194.289499] uvcvideo: Marking buffer as bad (error bit set).
> [  194.289505] uvcvideo: Frame complete (FID bit toggled).
> [  194.289511] uvcvideo: Marking buffer as bad (error bit set).
> [  194.289518] uvcvideo: Frame complete (FID bit toggled).
> [  194.289524] uvcvideo: Marking buffer as bad (error bit set).
> [  194.289531] uvcvideo: Frame complete (FID bit toggled).
>
> Last but not least, uvcvideo is un-bisectable because there were a few
> crash-fixes during the 3.3 development cycle. I started bisecting and got
> kernel panics.

Are the kernel panics related to uvcvideo ? There's one known bug introduced 
between v3.2 and v3.3 and fixed (before v3.3) in commit 
8e57dec0454d8a3ba987d18b3ab19922c766d4bc.

-- 
Regards,

Laurent Pinchart

