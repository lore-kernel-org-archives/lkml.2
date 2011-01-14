Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab1ANTCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:02:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44669 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1ANTCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AsGRFfAu/UwIBvZ4hHehAdfas2X9U9HxX565JI556SHn0kuKO+gJSfrsp+N7Jsr/jF
         QfG+OTdtuQ6CRlG4xd3sW40dUdvwgjG5lVpden5wqNrETOSK0KW3xU/cyWC1h/+UBcrT
         yAWaz9Tp2kVgaD4yKMR+MzE/QUzaXaDg60RUw=
MIME-Version: 1.0
In-Reply-To: <AANLkTin9R1CHKy_zSsx+7N0V-WWce=xcWkdxg70rxYhn@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<4D2CE5C8.60601@de.ibm.com>
	<AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
	<4D2D8ED0.6080807@de.ibm.com>
	<AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
	<alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
	<AANLkTimdnYHWfBE1nB+2EDRouO7_FoRByVboMYw8WaHB@mail.gmail.com>
	<AANLkTik=HYzW8--_W+qxi8S9QbAkf9ZZy=uLyaTeV+PC@mail.gmail.com>
	<alpine.LFD.2.00.1101121538470.8212@casper.infradead.org>
	<alpine.LFD.2.00.1101131752190.311@casper.infradead.org>
	<AANLkTimdPFGJxjWHPZ2kojxJoj76zDw2=fiwDiMrinjy@mail.gmail.com>
	<alpine.LFD.2.00.1101141633200.5594@casper.infradead.org>
	<AANLkTimkP48aPmUwi86EPA+KPODUv=4P1BAuMqb=Hx9Q@mail.gmail.com>
	<alpine.LFD.2.00.1101141824580.5594@casper.infradead.org>
	<AANLkTin9R1CHKy_zSsx+7N0V-WWce=xcWkdxg70rxYhn@mail.gmail.com>
Date: Fri, 14 Jan 2011 21:02:17 +0200
Message-ID: <AANLkTikhsCYu6dGBd9ozg4oGLVkEtgsC=uPHB=+36i15@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 8:40 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> On Fri, Jan 14, 2011 at 8:26 PM, James Simmons <jsimmons@infradead.org> wrote:
>>
>>> > Just as I thought. Even this breaks the nouveau driver.
>>> >
>>> > Could you now add also in the drm_fb_helper_fill_fix function
>>> >
>>> > DRM_INFO("pitch %d, depth %d\n", fb_helper->fb->pitch,
>>> >          fb_helper->fb->depth);
>>> >
>>> > I have a feeling the values are not right. Thanks.
>>> >
>>>
>>> Please make an patch to test.
>>
>> Done. I had to test the patch myself. No need to do a revert. Just apply
>> this patch to linus tree. Then send the dmesg to me. Thanks.
>>
>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
>> index 0307d60..beded14 100644
>> --- a/drivers/gpu/drm/drm_fb_helper.c
>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> @@ -609,6 +609,7 @@ EXPORT_SYMBOL(drm_fb_helper_fini);
>>
>>  void drm_fb_helper_fill_fix(struct fb_info *info, struct drm_framebuffer *fb)
>>  {
>> +       DRM_INFO("pitch %d, depth %d\n", fb->pitch, fb->depth);
>>        info->fix.type = FB_TYPE_PACKED_PIXELS;
>>        info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
>>                FB_VISUAL_TRUECOLOR;
>> @@ -973,7 +974,6 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
>>
>>        if (new_fb) {
>>                info->var.pixclock = 0;
>> -               drm_fb_helper_fill_fix(info, fb_helper->fb);
>>                if (register_framebuffer(info) < 0) {
>>                        return -EINVAL;
>>                }
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
>> index a26d047..fe87319 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
>> @@ -359,6 +359,7 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
>>        info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
>>        info->screen_size = size;
>>
>> +       drm_fb_helper_fill_fix(info, fb);
>>        drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
>>
>>        /* Set aperture base/size for vesafb takeover */
>
> I will test it, but first, I will need to disable the cassini driver,
> because it can not compile.
>

I will test this first:

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 0307d60..beded14 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -609,6 +609,7 @@ EXPORT_SYMBOL(drm_fb_helper_fini);

 void drm_fb_helper_fill_fix(struct fb_info *info, struct drm_framebuffer *fb)
 {
+       DRM_INFO("pitch %d, depth %d\n", fb->pitch, fb->depth);
        info->fix.type = FB_TYPE_PACKED_PIXELS;
        info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
                FB_VISUAL_TRUECOLOR;
@@ -973,7 +974,6 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_h

        if (new_fb) {
                info->var.pixclock = 0;
-               drm_fb_helper_fill_fix(info, fb_helper->fb);
                if (register_framebuffer(info) < 0) {
                        return -EINVAL;
                }
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/n
index a26d047..3896771 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 0307d60..beded14 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -609,6 +609,7 @@ EXPORT_SYMBOL(drm_fb_helper_fini);

 void drm_fb_helper_fill_fix(struct fb_info *info, struct drm_framebuffer *fb)
 {
+       DRM_INFO("pitch %d, depth %d\n", fb->pitch, fb->depth);
        info->fix.type = FB_TYPE_PACKED_PIXELS;
        info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
                FB_VISUAL_TRUECOLOR;
@@ -973,7 +974,6 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_h

        if (new_fb) {
                info->var.pixclock = 0;
-               drm_fb_helper_fill_fix(info, fb_helper->fb);
                if (register_framebuffer(info) < 0) {
                        return -EINVAL;
                }
