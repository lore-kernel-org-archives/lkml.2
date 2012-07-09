Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2GIG4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:56:25 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60766 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2GIG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:56:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
	<877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
	<4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com>
	<4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com>
	<4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com>
	<4FF085B1.6070604@zytor.com> <87a9zj9w43.fsf@xmission.com>
	<4FF098E2.3040307@zytor.com> <87sjdb8f0m.fsf@xmission.com>
	<4FF0A399.8070207@zytor.com> <87txxr6wre.fsf@xmission.com>
	<4FF0B891.8080804@zytor.com> <87k3yd5sxt.fsf@xmission.com>
	<87fw915sv4.fsf_-_@xmission.com>
Date: Sun, 08 Jul 2012 23:56:17 -0700
In-Reply-To: <87fw915sv4.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 08 Jul 2012 23:52:15 -0700")
Message-ID: <871ukl5soe.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18QW9RpsaXK9+YjM+Rt6GKYLr3NayD7fXM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: [PATCH 4/4] x86 boot: Tell ld the kernel doesn't want 2MB file offset alignment.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By default ld uses 2MB pages and aligns our 3 program segments in the
file on 2MB boundaries, creating unnecessarily large uncompressed
vmlinux files.

Solve this by passing -z max-page-size 4096 to ld.

In my test x86_64 SMP test configuration with CONFIG_DEBUG_RODATA
enabled, this reduces the size of vmlinux by roughly 5MB from 15141772
bytes to 10210188 bytes.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1f25214..b5b31c3 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -120,7 +120,7 @@ avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_
 KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr)
 KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr)
 
-LDFLAGS := -m elf_$(UTS_MACHINE)
+LDFLAGS := -m elf_$(UTS_MACHINE) -z max-page-size=4096
 
 # Speed up the build
 KBUILD_CFLAGS += -pipe
-- 
1.7.5.4

