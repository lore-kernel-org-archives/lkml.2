Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1AAM7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 07:59:04 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45371 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab1AAM7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 07:59:02 -0500
Date: Sat, 01 Jan 2011 07:58:30 -0500
Subject: Re: [PATCH 14/18] cx25840: Fix subdev registration in
 cx25840-core.c
Message-ID: <v38khxmtvlbmmvf5dv0i04b4.1293886218059@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: "Igor M. Liplianin" <liplianin@me.by>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org
Content-Type: text/plain; charset=utf-8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-01_01:2010-12-31,2011-01-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=100
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1101010021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p01CxT21029536

Igor,

The proper fix is here:

https://patchwork.kernel.org/patch/376612/

So, NAK on your particular patch.

Mauro,

I do not see the above patch at linux next.  And I couldn't find it in your kernel.org tree.  What is its status?

This fixes a regression that is known to break cx23885 hardware initialization and can break ivtv hardware initialization.

Regards,
Andy

"Igor M. Liplianin" <liplianin@me.by> wrote:

>On my system, cx23885 based card reports default volume value above 70000.
>So, register cx25840 subdev fails. Although, the card don't have a/v inputs
>it needs a/v firmware to be loaded.
>
>Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
>---
> drivers/media/video/cx25840/cx25840-core.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
>index dfb198d..dc0cec7 100644
>--- a/drivers/media/video/cx25840/cx25840-core.c
>+++ b/drivers/media/video/cx25840/cx25840-core.c
>@@ -1991,6 +1991,8 @@ static int cx25840_probe(struct i2c_client *client,
> 	if (!is_cx2583x(state)) {
> 		default_volume = 228 - cx25840_read(client, 0x8d4);
> 		default_volume = ((default_volume / 2) + 23) << 9;
>+		if (default_volume > 65535)
>+			default_volume = 65535;
> 
> 		state->volume = v4l2_ctrl_new_std(&state->hdl,
> 			&cx25840_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
>-- 
>1.7.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
