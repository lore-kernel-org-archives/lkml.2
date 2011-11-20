Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1KTQfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 11:35:21 -0500
Received: from nm6-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.71]:48207 "HELO
	nm6-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753055Ab1KTQfU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 11:35:20 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Nov 2011 11:35:20 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 211588.65798.bm@omp1040.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=o3sta9RNXrDK0Oew4bfIf9wPb/DM9gtlEHtbbn9rcCTt8oBQk3UFFJdWEpTobNbqowLpcHbeWFCR5Drs317kA5ABz1kFtSo38yEM/j79m0892S8CRqQLvp/bFtbWUsPOSWLt1BXjcMBCUgjk4ifU/dNngBRnXwioZNO8UJCzuvs=;
X-YMail-OSG: _q3mxq4VM1m0fR60bYhPv438d1aqrBdt.zoA4BiVl96jqux
 Chem62sZjzEyIr9AxFpPXfhPmaVXl.D7DJeEPC8QQ1FNcINpbBVCKfz7VS5T
 N5bnOoERkjmQ62iQR8_R7_VxUGykeWvh7QKw6Mc.1OqIguZdk18v1IIyKUSJ
 sn_lZ1.91.x.d3S9sbEI0qeiVH6DrtTK2t5dJsER02Mrq3uOmqkx67u01rnM
 juZr1FfEDs8mbi_kC_CnnZAHQW0naDpFjinTK6Epc75tyOOGGidF.IP15.TH
 bvEMxaVsvwqVhxU_nQf3Iw27qW9yO8tkIaDLBJmH9pVvcHZWAw0irB8IEYbA
 IqWKqIYzdwR_4EyIC0QRMnanM0Vgas27z5nW_tIBzUgO7_VhBlTv_VMjH4_p
 ggi9hXMH79rxaxP805OvsQG_F77hJ4xD_.7vneUs7h69MaVljC09ptyTVW_A
 XqbfLd0eU16Qw1KjSn4iyG5zc
X-Mailer: YahooMailWebService/0.8.115.331698
References: <s5hboscpexg.wl%tiwai@suse.de> <1321449575.23167.YahooMailNeo@web130111.mail.mud.yahoo.com>
Message-ID: <1321806537.81589.YahooMailNeo@web130111.mail.mud.yahoo.com>
Date: Sun, 20 Nov 2011 08:28:57 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH] drm/i915: Fix inconsistent backlight level during disabled
To: Takashi Iwai <tiwai@suse.de>, Keith Packard <keithp@keithp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>, "mjg@redhat.com" <mjg@redhat.com>
In-Reply-To: <1321449575.23167.YahooMailNeo@web130111.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>>index 499d4c0..21f60b7 100644
>>--- a/drivers/gpu/drm/i915/intel_panel.c
>>+++ b/drivers/gpu/drm/i915/intel_panel.c
>>@@ -326,7 +326,8 @@ static int intel_panel_update_status(struct backlight_device *bd)
>>static int intel_panel_get_brightness(struct backlight_device *bd)
>>{
>>    struct drm_device *dev = bl_get_data(bd);
>>-    return intel_panel_get_backlight(dev);
>>+    struct drm_i915_private *dev_priv = dev->dev_private;
>>+    return dev_priv->backlight_level;
>>}
>>
>>static const struct backlight_ops intel_panel_bl_ops = {
>>-- 
>>1.7.7
>
>I'll test this patch sometime this weekend.

This patch works for me.

Tested-by: Alex Davis<alex14641@yahoo.com>

