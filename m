Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1B1H2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 02:28:35 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4368 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1B1H2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 02:28:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Date: Mon, 28 Feb 2011 08:28:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110228120501.eb6840e0.sfr@canb.auug.org.au>
In-Reply-To: <20110228120501.eb6840e0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102280828.11058.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 28, 2011 02:05:01 Stephen Rothwell wrote:
> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/video/matrox/matroxfb_base.c: In function 'matroxfb_ioctl':
> drivers/video/matrox/matroxfb_base.c:1155: error: 'VIDIOC_S_CTRL_OLD' undeclared (first use in this function)
> 
> Caused by commit 0ff69fe7cebb65856eba7feb3fd76fb4ba365bf8 ("[media] v4l:
> removal of old, obsolete ioctls"). grep is your friend ...
> 
> I have used the v4l-dvb tree from next-20110225 for today.
> 

Mauro,

Here is the trivial fix for this. Must remember next time that matrox borrows
some of the V4L2 API.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index a082deb..4c49fb2 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1152,7 +1152,6 @@ static int matroxfb_ioctl(struct fb_info *info,
 					return -EFAULT;
 				return err;
 			}
-		case VIDIOC_S_CTRL_OLD:
 		case VIDIOC_S_CTRL:
 			{
 				struct v4l2_control ctrl;

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
