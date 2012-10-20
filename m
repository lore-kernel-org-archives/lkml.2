Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2JTJrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 05:47:20 -0400
Received: from iona.labri.fr ([147.210.8.143]:60807 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2JTJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 05:47:19 -0400
Message-ID: <50827174.7070109@labri.fr>
Date: Sat, 20 Oct 2012 11:40:04 +0200
From: Martin Peres <martin.peres@labri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Heinz Diehl <htd@fancy-poultry.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?UGF3ZcWCIFNp?= =?UTF-8?B?a29yYQ==?= 
	<pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
References: <1724445.dN2yMEzN6d@localhost> <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com> <20121020092647.GA3186@fancy-poultry.org>
In-Reply-To: <20121020092647.GA3186@fancy-poultry.org>
Content-Type: multipart/mixed;
 boundary="------------010808050707080104090307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010808050707080104090307
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/10/2012 11:26, Heinz Diehl wrote:
> On 20.10.2012, Linus Torvalds wrote:
>
>> Added more appropriate people to this. Added both i915 and nouveau
>> people, since apparently that fine piece of hardware has both.
>>
>> Guys, any ideas?
>
> Plese see https://lkml.org/lkml/2012/10/19/371 , this is the same
> thing going on. Reverting
>
>   Ben Skeggs <bskeggs@redhat.com>
>   drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB
>
> fixes the problem.

Can you test the attached patch too ? I rebased the previous one I sent 
on top on 3.7-rc1 as I accidentally used an older version.

Martin

--------------010808050707080104090307
Content-Type: text/x-patch;
 name="0001-drm-nouveau-bios-improve-error-handling-when-reading.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-drm-nouveau-bios-improve-error-handling-when-reading.pa";
 filename*1="tch"

>From f09d58dc23a6e48ed56a1d9bf803f800f0c59e83 Mon Sep 17 00:00:00 2001
From: Martin Peres <martin.peres@labri.fr>
Date: Sat, 20 Oct 2012 11:03:36 +0200
Subject: [PATCH] drm/nouveau/bios: improve error handling when reading the
 vbios from ACPI

Reported-by: Pawel Sikora <pawel.sikora@agmk.net>
Signed-off-by: Martin Peres <martin.peres@labri.fr>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
index 619e7e0..519a3b3 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
@@ -188,8 +188,10 @@ nouveau_bios_shadow_acpi(struct nouveau_bios *bios)
 	int ret, cnt, i;
 	u8  data[3];
 
-	if (!nouveau_acpi_rom_supported(pdev))
+	if (!nouveau_acpi_rom_supported(pdev)) {
+		bios->data = NULL;
 		return;
+	}
 
 	bios->size = 0;
 	if (nouveau_acpi_get_bios_chunk(data, 0, 3) == 3)
-- 
1.7.12.4


--------------010808050707080104090307--
