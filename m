Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2DPUjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab2DPUjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [EDAC ABI v13 20/25] i5100_edac: Fix a warning when compiled with 32 bits
Date: Mon, 16 Apr 2012 17:38:44 -0300
Message-Id: <1334608729-30803-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/edac/i5100_edac.c: In function ‘i5100_init_csrows’:
drivers/edac/i5100_edac.c:862:3: warning: format ‘%zd’ expects argument of type ‘signed size_t’, but argument 5 has type ‘long unsigned int’ [-Wformat]

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5100_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 11aba5e..dd260c8 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -859,8 +859,8 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 				i5100_rank_to_slot(mci, chan, rank));
 		}
 
-		debugf2("dimm channel %d, rank %d, size %zd\n",
-			chan, rank, PAGES_TO_MiB(npages));
+		debugf2("dimm channel %d, rank %d, size %ld\n",
+			chan, rank, (long)PAGES_TO_MiB(npages));
 	}
 }
 
-- 
1.7.8

