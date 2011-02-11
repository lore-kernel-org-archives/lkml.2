Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1BKTGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:06:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35121 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1BKTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hPBCG/fagPXDBkVk+G81H4sTUCt45k+1qLHXAn4s87S6uEnUZ0AdJv+p5nLDO9aI1U
         cBsvQaSZhlGVER+AvEZaLlqLKkU74XJiRrgWZqmCi2wa/Eyrc1TOscNKSc9NIqGJXgMY
         5Ns4JAoCIoeRRI8l9jUHc6/VxdUxcFsO6/rv0=
MIME-Version: 1.0
In-Reply-To: <C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com>
References: <4D51AD03.7030401@gmail.com>
	<AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
	<AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
	<B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
	<AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com>
	<AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com>
	<C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com>
Date: Fri, 11 Feb 2011 14:06:16 -0500
Message-ID: <AANLkTikn0sAnohS__1MET5qYiM6sYRc_Dg2cLaN3f3-C@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:57 AM, Justin Mattock
<justinmattock@gmail.com> wrote:
>
>>
>> Better yet, can you try the attached patch on top of 2.6.38-rc4 or newer?
>>
>> Alex
>>
>
> o.k. applied that patch... unfortunately Im seeing the flickering screen and
> the crud shows up..
> initially during boot everything looked fine, its when I suspended the
> machine, upon wake-up
> the flickering occurred.
> kernel version is the current: 2.6.38-rc4-00107-gaa502b4

Can you try the following patch on top of the first two patches I
posted to this thread?

Thanks,

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c
b/drivers/gpu/drm/radeon/atombios_crtc.c
index cc6bdd8..2f9d113 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -562,7 +562,7 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
                               }
                       }
 /* this might work properly with the new pll algo */
-#if 0 /* doesn't work properly on some laptops */
+#if 1 /* doesn't work properly on some laptops */
                       /* use recommended ref_div for ss */
                       if (radeon_encoder->devices &
(ATOM_DEVICE_LCD_SUPPORT)) {
                               if (ss_enabled) {


>
> Justin P. Mattock
>
