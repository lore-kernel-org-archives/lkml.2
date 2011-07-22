Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1GVOfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:35:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab1GVOfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:35:04 -0400
Date: Fri, 22 Jul 2011 16:34:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.1
Message-ID: <20110722143425.GA12801@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Greg Dietsche (1):
      x86, smpboot: Mark the names[] array in __inquire_remote_apic() as const

Joe Perches (1):
      x86: Convert vmalloc()+memset() to vzalloc()


 arch/x86/kernel/smpboot.c   |    2 +-
 arch/x86/mm/pageattr-test.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a3c430b..e02653a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -425,7 +425,7 @@ static void impress_friends(void)
 void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-	char *names[] = { "ID", "VERSION", "SPIV" };
+	const char * const names[] = { "ID", "VERSION", "SPIV" };
 	int timeout;
 	u32 status;
 
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index e1d1069..b008656 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -123,12 +123,11 @@ static int pageattr_test(void)
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
 
-	bm = vmalloc((max_pfn_mapped + 7) / 8);
+	bm = vzalloc((max_pfn_mapped + 7) / 8);
 	if (!bm) {
 		printk(KERN_ERR "CPA Cannot vmalloc bitmap\n");
 		return -ENOMEM;
 	}
-	memset(bm, 0, (max_pfn_mapped + 7) / 8);
 
 	failed += print_split(&sa);
 	srandom32(100);
