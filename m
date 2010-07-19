Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967004Ab0GSVkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:40:32 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33725 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966845Ab0GSVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:40:27 -0400
Subject: Re: [PATCH 1/1] VIDEO: ivtvfb, remove unneeded NULL test
From: Andy Walls <awalls@md.metrocast.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <1279561174-12468-1-git-send-email-jslaby@suse.cz>
References: <1278346795.2229.2.camel@localhost>
	 <1279561174-12468-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 17:39:00 -0400
Message-ID: <1279575540.32733.4.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-07-19_07:2010-07-19,2010-07-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1007190117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 19:39 +0200, Jiri Slaby wrote:
> Stanse found that in ivtvfb_callback_cleanup and ivtvfb_callback_init
> there are unneeded tests for itv being NULL. But itv is initialized
> as container_of with non-zero offset in those functions, so it is
> never NULL (even if v4l2_dev is). This was found because itv is
> dereferenced earlier than the test.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Andy Walls <awalls@md.metrocast.net>

Looks fine to me.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ian Armstrong <ian@iarmst.demon.co.uk>
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/video/ivtv/ivtvfb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
> index 9ff3425..9c77bfa 100644
> --- a/drivers/media/video/ivtv/ivtvfb.c
> +++ b/drivers/media/video/ivtv/ivtvfb.c
> @@ -1203,7 +1203,7 @@ static int __init ivtvfb_callback_init(struct device *dev, void *p)
>  	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
>  	struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
>  
> -	if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
> +	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>  		if (ivtvfb_init_card(itv) == 0) {
>  			IVTVFB_INFO("Framebuffer registered on %s\n",
>  					itv->v4l2_dev.name);
> @@ -1219,7 +1219,7 @@ static int ivtvfb_callback_cleanup(struct device *dev, void *p)
>  	struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
>  	struct osd_info *oi = itv->osd_info;
>  
> -	if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
> +	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>  		if (unregister_framebuffer(&itv->osd_info->ivtvfb_info)) {
>  			IVTVFB_WARN("Framebuffer %d is in use, cannot unload\n",
>  				       itv->instance);


