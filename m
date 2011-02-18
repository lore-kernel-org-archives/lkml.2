Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1BRJRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:17:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61497 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1BRJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QnRmGxI1ZmuePCTc7Mpi8XUZjOanGuYa5p1puQVD5b5fnUb3cSMDZr+JIzubOURlkI
         paTFgSBAt4Q1sSTwfEj+V0b/JCzwib0EM8m4ZpddMSiRG4ygIRuDcCltYRFliyd4PWRG
         N1PzcAgyiDWxEjdry5lUXSGz5lMUO3fJOwYXQ=
Date: Fri, 18 Feb 2011 12:17:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] x86, microcode, AMD: signedness bug in
 generic_load_microcode()
Message-ID: <20110218091716.GA4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
	open list <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

install_equiv_cpu_table() returns type int.  It uses negative error
codes so using an unsigned type breaks the error handling.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 9fb8405..c561038 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -246,7 +246,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_header_amd *mc_hdr = NULL;
 	unsigned int mc_size, leftover;
-	unsigned long offset;
+	int offset;
 	const u8 *ucode_ptr = data;
 	void *new_mc = NULL;
 	unsigned int new_rev = uci->cpu_sig.rev;
