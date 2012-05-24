Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2EXIdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:33:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62483 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2EXIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:32:58 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-4c-4fbdf2381cc1
From: KyongHo <pullip.cho@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: mm: fix faulty initialization in vmalloc_init()
Date: Thu, 24 May 2012 17:32:56 +0900
Organization: Samsung Electronics Co., Ltd.
Message-id: <001c01cd3987$d1a71a50$74f54ef0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac05h8wIIJvGn+NBSFuLveW10sPwAA==
Content-language: ko
x-cr-hashedpuzzle: BIhf GvR5 HoFQ NuYo N5x5 O9Gp PY7x QBZ4 R36y Szn+ Vpb+ mimz
 wDSK z624 2RCw
 3x0A;5;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AbQBAAGsAdgBhAGMAawAuAG8AcgBnADsAbABpAG4AdQB4AC0AcwBhAG0AcwB1AG4AZwAtAHMAbwBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{ECD3ABAD-E4BA-484E-9B02-074F0AD5E0C0};cAB1AGwAbABpAHAALgBjAGgAbwBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 24 May 2012 08:32:47
 GMT;bQBtADoAIABmAGkAeAAgAGYAYQB1AGwAdAB5ACAAaQBuAGkAdABpAGEAbABpAHoAYQB0AGkAbwBuACAAaQBuACAAdgBtAGEAbABsAG8AYwBfAGkAbgBpAHQAKAApAA==
x-cr-puzzleid: {ECD3ABAD-E4BA-484E-9B02-074F0AD5E0C0}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jAV2LT3v9Dab91LS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MqYd2g5c8Eetoq26X4NjLNZuxg5OSQETCQWrtzBBmGL
	SVy4tx7I5uIQEljEKHHmzUNGkISQwD9GiXfbAkBsNgE1iVtn/4A1iwA1b+98ygTSwCwwi1Hi
	6dNZTCAJYQELiYdvfrKD2CwCqhJ/Tl4FG8QvoC2x9tp7FhCbV8BW4smBVmYIW1Dix+R7YHFm
	AS2J9TuPM0HY8hKb17wFquEAuk5d4tFfXYi9ehLPT/1ggygRkdj34h0jyA0SAn9YJWbMPAj1
	malE2933LBMYhWchWTELyYpZSFbMQjJrASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg
	UH8mvYNxVYPFIUYBDkYlHt5rb/f6C7EmlhVX5h5ilOBgVhLhzXkCFOJNSaysSi3Kjy8qzUkt
	PsQozcGiJM77ZMkOfyGB9MSS1OzU1ILUIpgsEwenVAPjIrtsrpL0mCWigdtuTjhadbnj1TL+
	ls17n1tZLa6d+Mvt/hbhD+fvS09ZOPHRx/dz2kr8Tb/c2MwdUL86/sccX70bN6Y+XZg36Xqo
	xGzfR94rzwa9m30psyHqkuzqZT/frZ+msHuvCUt6RrrvCW97hq0HHOyf/EjnucvzZEIXy5Lq
	M1Kffs24skiJpTgj0VCLuag4EQByzmQYcQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc_init() adds 'vmap_area's for early 'vm_struct's.
This patch fixes vmalloc_init() to correctly initialize
vmap_area for the given vm_struct.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 mm/vmalloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 94dff88..1196c77 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1185,9 +1185,10 @@ void __init vmalloc_init(void)
 	/* Import existing vmlist entries. */
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
-		va->flags = tmp->flags | VM_VM_AREA;
+		va->flags = VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
+		va->vm = tmp;
 		__insert_vmap_area(va);
 	}
 
-- 
1.7.1


