Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1ERQL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:11:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab1ERQJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:08 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=HDKBsaQA1egA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=AQyPVmDVT9TJbUHP9-AA:9 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160907.196356540@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 05/15] ftrace/recordmcount: Modify only executable sections
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-recordmcount-Modify-only-executable-sections.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

PROGBITS is not enough to determine if the section should be modified
or not. Only process sections that are marked as executable.

Cc: John Reiser <jreiser@bitwagon.com>
Link: http://lkml.kernel.org/r/20110421023737.991485123@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index ac7b330..7f8d5c4 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -360,6 +360,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 		succeed_file();
 	}
 	if (w(txthdr->sh_type) != SHT_PROGBITS ||
+	    !(w(txthdr->sh_flags) & SHF_EXECINSTR) ||
 	    !is_mcounted_section_name(txtname))
 		return NULL;
 	return txtname;
-- 
1.7.4.4


