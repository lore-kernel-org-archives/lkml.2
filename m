Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab2EXQKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:10:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378Ab2EXQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:09:59 -0400
Date: Thu, 24 May 2012 09:09:38 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-ea17e7414bc62e8d3bde8d08e3df1d921c518c17@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sfr@canb.auug.org.au, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sfr@canb.auug.org.au
In-Reply-To: <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
References: <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, relocs:
  Add jiffies and jiffies_64 to the relative whitelist
Git-Commit-ID: ea17e7414bc62e8d3bde8d08e3df1d921c518c17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 09:09:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea17e7414bc62e8d3bde8d08e3df1d921c518c17
Gitweb:     http://git.kernel.org/tip/ea17e7414bc62e8d3bde8d08e3df1d921c518c17
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 24 May 2012 07:01:38 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 24 May 2012 07:16:18 -0700

x86, relocs: Add jiffies and jiffies_64 to the relative whitelist

The symbol jiffies is created in the linker script as an alias to
jiffies_64.  Unfortunately this is done outside any section, and
apparently GNU ld 2.21 doesn't carry the section with it, so we end up
with an absolute symbol and therefore a broken kernel.

Add jiffies and jiffies_64 to the whitelist.

The most disturbing bit with this discovery is that it shows that we
have had multiple linker bugs in this area crossing multiple
generations, and have been silently building bad kernels for some time.

Link: http://lkml.kernel.org/r/20120524171604.0d98284f3affc643e9714470@canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org> v3.4
---
 arch/x86/tools/relocs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index b8f7c65..b685296 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -71,6 +71,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__(start|stop)_notes|"
 	"__end_rodata|"
 	"__initramfs_start|"
+	"(jiffies|jiffies_64)|"
 	"_end)$"
 };
 
