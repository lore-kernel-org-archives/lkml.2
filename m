Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1DUChm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:37:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1DUChj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:39 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Vz7ZXWTSTL8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=AQyPVmDVT9TJbUHP9-AA:9 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421023737.991485123@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Reiser <jreiser@bitwagon.com>
Subject: [RFC][PATCH 04/11] ftrace/recordmcount: Modify only executable sections
References: <20110421022825.535486725@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-recordmcount-Modify-only-executable-sections.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

PROGBITS is not enough to determine if the section should be modified
or not. Only process sections that are marked as executable.

Cc: John Reiser <jreiser@bitwagon.com>
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
1.7.2.3


