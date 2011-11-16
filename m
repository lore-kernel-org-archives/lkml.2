Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1KPN0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:26:12 -0500
Received: from nm23.bullet.mail.ac4.yahoo.com ([98.139.52.220]:33629 "HELO
	nm23.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756620Ab1KPN0L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:26:11 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 08:26:11 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 423631.33359.bm@omp1031.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5vBE36oCv3XZJvjdmCxMX7OqgcXrElcbfP12bUJeWi5vn8WRHR4VwaeizC8BimyL1SKhWd/nfBnINfB3+U+7w2Tsu95zfLqMM9g8snUHROyHmulzFo/wmBb0//Q22p8PFo5o72ArrG4A+sf3AaDeQ6DbFLsq1V8k0zeouB2GwIk=;
X-YMail-OSG: WQGWpz8VM1kBX5i8wOOUS2OLEjd63wEwywmKfVWvXyAgvxQ
 sh2idH6d7g_.OCzZNENKFI52JZrl9JmGkDTyM99UALjQoPRIIQm5qTLbXCb2
 Swf7XndQ2gQkx5EedtJ6yU2ZFtBDjpdEFLBNLW3z9JJQRGKqFQC14bzmgGzs
 RDcONzIP0_FQgk5pyxg6F26MHsb69jWtg3Xsn8EQhNe4lXXdWQED_1UD92Lm
 5jcqlMEccpQXv7td8QZAWp3q28dCUgRxr0kX5jxh6wiSEf5ILSmX26_I5gKO
 hXhzxKaOwLnVPGfVqcSQMoxc0RicRpn0vqusyEPrj6H3.qUqFMtVT3.YVPNr
 U7xru.gw8FBg9Jwl8HTquOSDKC77ICHEnE8hDyJnPqGgycmwGd0CKDY9vops
 xpAUlVY.etZPv1Pvf0eFqAcgkPhCTF9r90DD4ve6mla1I4ILpBXCR_MBS9S_
 Djs0JsJ4NC1JntrYV0zH8Igpx
X-Mailer: YahooMailWebService/0.8.115.325013
References: <s5hboscpexg.wl%tiwai@suse.de>
Message-ID: <1321449575.23167.YahooMailNeo@web130111.mail.mud.yahoo.com>
Date: Wed, 16 Nov 2011 05:19:35 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH] drm/i915: Fix inconsistent backlight level during disabled
To: Takashi Iwai <tiwai@suse.de>, Keith Packard <keithp@keithp.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>, "mjg@redhat.com" <mjg@redhat.com>
In-Reply-To: <s5hboscpexg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>index 499d4c0..21f60b7 100644
>--- a/drivers/gpu/drm/i915/intel_panel.c
>+++ b/drivers/gpu/drm/i915/intel_panel.c
>@@ -326,7 +326,8 @@ static int intel_panel_update_status(struct backlight_device *bd)
>static int intel_panel_get_brightness(struct backlight_device *bd)
>{
>    struct drm_device *dev = bl_get_data(bd);
>-    return intel_panel_get_backlight(dev);
>+    struct drm_i915_private *dev_priv = dev->dev_private;
>+    return dev_priv->backlight_level;
>}
>
>static const struct backlight_ops intel_panel_bl_ops = {
>-- 
>1.7.7

I'll test this patch sometime this weekend.

