Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1BKG7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:59:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62369 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1BKG7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=taxlVfHufJ1vbJiQc5cVZp91usq026R3AlUFjyB/WuwGFq/1vfTmP4ojiLTRPjBImk
         Wou0hbr+jLALQdADqyRHGD8jlux2itvO8oaIq9ctY7yjkZ/QHKJLqRftOEBHQzX0Itva
         /D5G9fCSrDYkQze1rSNfXQBlQgjNkcwaAgPxc=
MIME-Version: 1.0
In-Reply-To: <B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
References: <4D51AD03.7030401@gmail.com>
	<AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
	<AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
	<B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
Date: Fri, 11 Feb 2011 01:59:22 -0500
Message-ID: <AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 12:33 AM, Justin Mattock
<justinmattock@gmail.com> wrote:
>
> On Feb 9, 2011, at 2:09 PM, Alex Deucher wrote:
>
>> On Tue, Feb 8, 2011 at 4:20 PM, Alex Deucher <alexdeucher@gmail.com>
>> wrote:
>>>
>>> On Tue, Feb 8, 2011 at 3:52 PM, Justin P. Mattock
>>> <justinmattock@gmail.com> wrote:
>>>>
>>>> With the current HEAD Im getting screen flickering really bad to point
>>>> where
>>>> it looks like the screen is damaged and/or half plugged-in etc..
>>>>
>>>> the bisect pointed to here:
>>>>
>>>> commit 619efb105924d8cafa0c1dd9389e9ab506f5425d
>>>>
>>>> doing a git revert 619efb10592
>>>> gets the screen working properly again.
>>>> I havent looked much through the code to see if I can fix this. for the
>>>> time
>>>> being I'll revert this on my machine with the current, until later on.
>>>
>>> The attached patch should fix it assuming I got your pci ids correct.
>>> I'm done with the pll stuff; too may fixes break other boards.  Just
>>> add a quirk table and be done with it.
>>>
>>
>> The attached patch builds on the previous one and fixes an additional
>> regression.
>>
>> Alex
>>
>> <0001-drm-radeon-kms-pll-quirk-cleanup.patch>
>
> alright... didn't mean to keep you waiting(out of my office for most of the
> day)..
> Anyways patch applied, and everything looks good no screen jitters or
> flickering etc..
>
> Reported-and-Tested-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Thanks for sending this my way so my machine works..

Justin, can you try without these patches, but with the following patch instead?

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
> cheers,
>
> Justin P. Mattock
>
