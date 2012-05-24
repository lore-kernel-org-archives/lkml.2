Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab2EXUca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab2EXUc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:32:29 -0400
Date: Thu, 24 May 2012 13:32:08 -0700
Message-Id: <201205242032.q4OKW8fx031844@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 - additional relocation fixes
Cc: <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 13:32:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are additional symbols that have been found to either be
absolute or look like they might end up being absolute on one version
of GNU ld or another.  Unfortunately we have since that a different
GNU ld version, 2.21, can generate bogus absolute symbols; again, this
would have caused a malfunctioning kernel on x86-32 if relocated.

The relocs.c changes changed silent corruption to a build time error.

It is worth noting that if the various barrier symbols we use were
more consistent in the namespace used this probably could be reduced
to a single regexp; if nothing else it looks like there is migration
toward a common __(start|stop)___.* namespace.

Greg: these builds are tagged for stable v3.4, but if the relocs.c
changes are backported then you will need these patches for the
backports as well.

The following changes since commit b2d668da9307c4c163dd603d2bb3cadb10f9fd37:

  x86, relocs: Build clean fix (2012-05-21 12:19:37 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is ea17e7414bc62e8d3bde8d08e3df1d921c518c17.

H. Peter Anvin (2):
      x86-32, relocs: Whitelist more symbols for ld bug workaround
      x86, relocs: Add jiffies and jiffies_64 to the relative whitelist

 arch/x86/tools/relocs.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

 arch/x86/tools/relocs.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index b43cfcd..b685296 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -60,6 +60,18 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__x86_cpu_dev_(start|end)|"
 	"(__parainstructions|__alt_instructions)(|_end)|"
 	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"__(start|end)_pci_.*|"
+	"__(start|end)_builtin_fw|"
+	"__(start|stop)___ksymtab(|_gpl|_unused|_unused_gpl|_gpl_future)|"
+	"__(start|stop)___kcrctab(|_gpl|_unused|_unused_gpl|_gpl_future)|"
+	"__(start|stop)___param|"
+	"__(start|stop)___modver|"
+	"__(start|stop)___bug_table|"
+	"__tracedata_(start|end)|"
+	"__(start|stop)_notes|"
+	"__end_rodata|"
+	"__initramfs_start|"
+	"(jiffies|jiffies_64)|"
 	"_end)$"
 };
 
