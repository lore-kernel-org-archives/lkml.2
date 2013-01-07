Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3AGCJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:09:18 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51810 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311Ab3AGCJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:09:15 -0500
References: <1357523523-39707-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: K-9 Mail for Android
In-Reply-To: <1357523523-39707-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] media: cx18, ivtv: eliminate unnecessary array index checks
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 06 Jan 2013 21:08:39 -0500
To: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Message-ID: <041715b8-e711-4c63-a123-296c5b674edf@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-07_01:2013-01-04,2013-01-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1211240000 definitions=main-1301060338
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

>The idx values passed to cx18_i2c_register() and ivtv_i2c_register()
>by cx18_init_subdevs() and ivtv_load_and_init_modules() respectively
>are always in-range, based on how the hw_all bitmask is populated.
>Previously, the checks were already ineffective because arrays were
>being dereferenced using the index before the check.
>
>Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
>---
>Thanks to Andy Walls for suggesting that instead of moving the checks
>before array dereference, a better fix is to remove the checks
>altogether,
>since they are superfluous.
>
> drivers/media/pci/cx18/cx18-i2c.c |    3 ---
> drivers/media/pci/ivtv/ivtv-i2c.c |    2 --
> 2 files changed, 5 deletions(-)
>
>diff --git a/drivers/media/pci/cx18/cx18-i2c.c
>b/drivers/media/pci/cx18/cx18-i2c.c
>index 4908eb7..ccb1d15 100644
>--- a/drivers/media/pci/cx18/cx18-i2c.c
>+++ b/drivers/media/pci/cx18/cx18-i2c.c
>@@ -116,9 +116,6 @@ int cx18_i2c_register(struct cx18 *cx, unsigned
>idx)
> 	const char *type = hw_devicenames[idx];
> 	u32 hw = 1 << idx;
> 
>-	if (idx >= ARRAY_SIZE(hw_addrs))
>-		return -1;
>-
> 	if (hw == CX18_HW_TUNER) {
> 		/* special tuner group handling */
> 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
>diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c
>b/drivers/media/pci/ivtv/ivtv-i2c.c
>index 46e262b..bc984af 100644
>--- a/drivers/media/pci/ivtv/ivtv-i2c.c
>+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
>@@ -267,8 +267,6 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned
>idx)
> 	const char *type = hw_devicenames[idx];
> 	u32 hw = 1 << idx;
> 
>-	if (idx >= ARRAY_SIZE(hw_addrs))
>-		return -1;
> 	if (hw == IVTV_HW_TUNER) {
> 		/* special tuner handling */
> 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,
>-- 
>1.7.10.4

Acked-by: Andy Walls <awalls@md.metrocast.net>
