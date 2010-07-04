Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0GDHYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:24:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59283 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0GDHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=McCmVaPFYSNky4rEIBxprB37B6LMdvOmAMxmJaAflBIcBYMwj0S/d9vxlpFdE/zCAb
         QHdEYzld3gK/+kfsotydvmVtGBvt1qAXPOCXbqNkry7sJPfCS7Aehuhi9Ss/9sFQMzLm
         RZgE90lZ3TWbdEQ+mM0KXeQmFtae2HKoSLUQ8=
Message-ID: <4C30372D.9050304@suse.cz>
Date: Sun, 04 Jul 2010 09:24:29 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] VIDEO: ivtvfb, remove unneeded NULL test
References: <1277206910-27228-1-git-send-email-jslaby@suse.cz> <1278216707.2644.32.camel@localhost>
In-Reply-To: <1278216707.2644.32.camel@localhost>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2010 06:11 AM, Andy Walls wrote:
> You missed an identical instance of the useless test 10 lines prior in
> ivtvfb_callback_init(). :)

Ah, thank you for pointing out. Find my comment below.

> --- a/drivers/media/video/ivtv/ivtvfb.c
> +++ b/drivers/media/video/ivtv/ivtvfb.c
> @@ -1201,9 +1201,14 @@ static int ivtvfb_init_card(struct ivtv *itv)
>  static int __init ivtvfb_callback_init(struct device *dev, void *p)
>  {
>         struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
> -       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
> +       struct ivtv *itv;
>  
> -       if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
> +       if (v4l2_dev == NULL)
> +               return 0;
> +
> +       itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
> +
> +       if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>                 if (ivtvfb_init_card(itv) == 0) {
>                         IVTVFB_INFO("Framebuffer registered on %s\n",
>                                         itv->v4l2_dev.name);
> @@ -1216,10 +1221,16 @@ static int __init ivtvfb_callback_init(struct device *de
>  static int ivtvfb_callback_cleanup(struct device *dev, void *p)
>  {
>         struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
> -       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
> -       struct osd_info *oi = itv->osd_info;
> +       struct ivtv *itv;
> +       struct osd_info *oi;
> +
> +       if (v4l2_dev == NULL)
> +               return 0;

>From my POV I NACK this. Given that it never triggered and drvdata are
set in v4l2_device_register called from ivtv_probe I can't see how
v4l2_dev be NULL. Could you elaborate?

-- 
js
suse labs
