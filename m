Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1FPOFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:05:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:52018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab1FPOFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:05:39 -0400
Date: Thu, 16 Jun 2011 14:05:31 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-df2ccb69454d022ce99e3a3b7ee7f9fb4a4e9563@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
In-Reply-To: <20110421023737.991485123@goodmis.org>
References: <20110421023737.991485123@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/recordmcount: Modify only executable sections
Git-Commit-ID: df2ccb69454d022ce99e3a3b7ee7f9fb4a4e9563
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 14:05:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df2ccb69454d022ce99e3a3b7ee7f9fb4a4e9563
Gitweb:     http://git.kernel.org/tip/df2ccb69454d022ce99e3a3b7ee7f9fb4a4e9563
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 13 Apr 2011 13:31:08 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 17 May 2011 10:41:39 -0400

ftrace/recordmcount: Modify only executable sections

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
