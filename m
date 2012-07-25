Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2GYQTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:19:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab2GYQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:19:06 -0400
Date: Wed, 25 Jul 2012 09:18:53 -0700
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-lww2uirad4skzjlmrm0vru8o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, stable@vger.kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, nops:
  Missing break resulting in incorrect selection on Intel
Git-Commit-ID: d6250a3f12edb3a86db9598ffeca3de8b4a219e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 09:18:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6250a3f12edb3a86db9598ffeca3de8b4a219e9
Gitweb:     http://git.kernel.org/tip/d6250a3f12edb3a86db9598ffeca3de8b4a219e9
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Wed, 25 Jul 2012 16:28:19 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 25 Jul 2012 08:35:38 -0700

x86, nops: Missing break resulting in incorrect selection on Intel

The Intel case falls through into the generic case which then changes
the values.  For cases like the P6 it doesn't do the right thing so
this seems to be a screwup.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-lww2uirad4skzjlmrm0vru8o@git.kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1f84794..73ef56c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -219,7 +219,7 @@ void __init arch_init_ideal_nops(void)
 			ideal_nops = intel_nops;
 #endif
 		}
-
+		break;
 	default:
 #ifdef CONFIG_X86_64
 		ideal_nops = k8_nops;
