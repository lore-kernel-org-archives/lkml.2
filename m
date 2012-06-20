Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2FTRFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:05:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab2FTRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:05:48 -0400
Date: Wed, 20 Jun 2012 10:05:22 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-e1b6fc55da40bc17e20795901cb786e3619f9be9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FDF1EFD020000780008A65D@nat28.tlf.novell.com>
References: <4FDF1EFD020000780008A65D@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/microcode: Mark microcode_id[] as __initconst
Git-Commit-ID: e1b6fc55da40bc17e20795901cb786e3619f9be9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 10:05:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1b6fc55da40bc17e20795901cb786e3619f9be9
Gitweb:     http://git.kernel.org/tip/e1b6fc55da40bc17e20795901cb786e3619f9be9
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 18 Jun 2012 11:28:45 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Jun 2012 14:33:47 +0200

x86/microcode: Mark microcode_id[] as __initconst

It's not being used for other than creating module aliases (i.e.
no loadable section has any reference to it).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4FDF1EFD020000780008A65D@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/microcode_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fbdfc69..c383b3f 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -504,7 +504,7 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 
 #ifdef MODULE
 /* Autoload on Intel and AMD systems */
-static const struct x86_cpu_id microcode_id[] = {
+static const struct x86_cpu_id __initconst microcode_id[] = {
 #ifdef CONFIG_MICROCODE_INTEL
 	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, },
 #endif
