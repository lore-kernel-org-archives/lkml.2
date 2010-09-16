Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0IPBCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 21:02:39 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60592 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab0IPBCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 21:02:38 -0400
Date: Wed, 15 Sep 2010 20:59:19 -0400
Subject: Re: [PATCH] drivers/media/video/ivtv/ivtvfb.c: prevent reading
 uninitialized stack memory
Message-ID: <o1tfvx3ftkp8gaxheeq61r4w.1284598759859@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=utf-8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-15_19:2010-09-16,2010-09-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009150135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8G12oIh026774

Acked-by: Andy Walls <awalls@md.metrocast.net>

By tomorrow evening I'll put this in my repo and ask for Mauro to pull it.

Regards,
Andy

Dan Rosenberg <drosenberg@vsecurity.com> wrote:

>The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16
>bytes of uninitialized stack memory, because the "reserved" member of
>the fb_vblank struct declared on the stack is not altered or zeroed
>before being copied back to the user.  This patch takes care of it.
>
>Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>
>--- linux-2.6.35.4.orig/drivers/media/video/ivtv/ivtvfb.c	2010-08-26 19:47:12.000000000 -0400
>+++ linux-2.6.35.4/drivers/media/video/ivtv/ivtvfb.c	2010-09-15 14:16:46.797375399 -0400
>@@ -458,6 +458,8 @@ static int ivtvfb_ioctl(struct fb_info *
> 			struct fb_vblank vblank;
> 			u32 trace;
> 
>+			memset(&vblank, 0, sizeof(struct fb_vblank));
>+
> 			vblank.flags = FB_VBLANK_HAVE_COUNT |FB_VBLANK_HAVE_VCOUNT |
> 					FB_VBLANK_HAVE_VSYNC;
> 			trace = read_reg(IVTV_REG_DEC_LINE_FIELD) >> 16;
>
>
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
