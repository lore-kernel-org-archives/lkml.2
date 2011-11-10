Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014Ab1KJJb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:31:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933998Ab1KJJby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:31:54 -0500
Date: Thu, 10 Nov 2011 10:30:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: instruction decoder warnings: Warning: objdump says 5 bytes, but
 insn_get_length() says 3
Message-ID: <20111110093011.GA27149@elte.hu>
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


FYI, latest -tip (x86, 64-bit, allyesconfig) produces these warnings:

Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b709:	c5 f9 73 de 04       	vpsrldq 
$0x4,%xmm6,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b72b:	c5 b1 73 fd 0c       	vpslldq 
$0xc,%xmm5,%xmm9
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b730:	c5 f9 72 f5 01       	vpslld 
$0x1,%xmm5,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b752:	c5 d1 72 d5 1f       	vpsrld 
$0x1f,%xmm5,%xmm5
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b75b:	c4 c1 51 72 f1 02    	vpslld 
$0x2,%xmm9,%xmm5
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b761:	c4 c1 31 72 d1 1e    	vpsrld 
$0x1e,%xmm9,%xmm9
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b7ae:	c5 f9 73 dd 04       	vpsrldq 
$0x4,%xmm5,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b7d1:	c5 b1 73 fc 0c       	vpslldq 
$0xc,%xmm4,%xmm9
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b7d6:	c5 f9 72 f4 01       	vpslld 
$0x1,%xmm4,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b7f8:	c5 d9 72 d4 1f       	vpsrld 
$0x1f,%xmm4,%xmm4
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b801:	c4 c1 59 72 f1 02    	vpslld 
$0x2,%xmm9,%xmm4
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b807:	c4 c1 31 72 d1 1e    	vpsrld 
$0x1e,%xmm9,%xmm9
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b856:	c5 f9 73 dc 04       	vpsrldq 
$0x4,%xmm4,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b878:	c5 b1 73 fb 0c       	vpslldq 
$0xc,%xmm3,%xmm9
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b87d:	c5 f9 72 f3 01       	vpslld 
$0x1,%xmm3,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b89f:	c5 e1 72 d3 1f       	vpsrld 
$0x1f,%xmm3,%xmm3
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b8a8:	c4 c1 61 72 f1 02    	vpslld 
$0x2,%xmm9,%xmm3
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b8ae:	c4 c1 31 72 d1 1e    	vpsrld 
$0x1e,%xmm9,%xmm9
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b8fd:	c5 f9 73 db 04       	vpsrldq 
$0x4,%xmm3,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b91f:	c5 b1 73 fa 0c       	vpslldq 
$0xc,%xmm2,%xmm9
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b924:	c5 f9 72 f2 01       	vpslld 
$0x1,%xmm2,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b946:	c5 e9 72 d2 1f       	vpsrld 
$0x1f,%xmm2,%xmm2
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b94f:	c4 c1 69 72 f1 02    	vpslld 
$0x2,%xmm9,%xmm2
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b955:	c4 c1 31 72 d1 1e    	vpsrld 
$0x1e,%xmm9,%xmm9
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b9de:	c5 f9 72 f1 02       	vpslld 
$0x2,%xmm1,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108b9e3:	c5 f1 72 d1 1e       	vpsrld 
$0x1e,%xmm1,%xmm1
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108ba5f:	c4 c1 79 72 f0 02    	vpslld 
$0x2,%xmm8,%xmm0
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108ba65:	c4 c1 39 72 d0 1e    	vpsrld 
$0x1e,%xmm8,%xmm8
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bae2:	c5 f9 72 f7 02       	vpslld 
$0x2,%xmm7,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bae7:	c5 c1 72 d7 1e       	vpsrld 
$0x1e,%xmm7,%xmm7
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bb62:	c5 f9 72 f6 02       	vpslld 
$0x2,%xmm6,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bb67:	c5 c9 72 d6 1e       	vpsrld 
$0x1e,%xmm6,%xmm6
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bbe1:	c5 f9 72 f5 02       	vpslld 
$0x2,%xmm5,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bbe6:	c5 d1 72 d5 1e       	vpsrld 
$0x1e,%xmm5,%xmm5
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bc61:	c5 f9 72 f4 02       	vpslld 
$0x2,%xmm4,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bc66:	c5 d9 72 d4 1e       	vpsrld 
$0x1e,%xmm4,%xmm4
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bcf3:	c5 f9 72 f3 02       	vpslld 
$0x2,%xmm3,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bcf8:	c5 e1 72 d3 1e       	vpsrld 
$0x1e,%xmm3,%xmm3
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bd8b:	c5 f9 72 f2 02       	vpslld 
$0x2,%xmm2,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bd90:	c5 e9 72 d2 1e       	vpsrld 
$0x1e,%xmm2,%xmm2
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108be23:	c5 f9 72 f1 02       	vpslld 
$0x2,%xmm1,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108be28:	c5 f1 72 d1 1e       	vpsrld 
$0x1e,%xmm1,%xmm1
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108beba:	c4 c1 79 72 f0 02    	vpslld 
$0x2,%xmm8,%xmm0
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bec0:	c4 c1 39 72 d0 1e    	vpsrld 
$0x1e,%xmm8,%xmm8
Warning: objdump says 6 bytes, but insn_get_length() says 4
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bf55:	c5 f9 72 f7 02       	vpslld 
$0x2,%xmm7,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bf5a:	c5 c1 72 d7 1e       	vpsrld 
$0x1e,%xmm7,%xmm7
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bfe6:	c5 f9 72 f6 02       	vpslld 
$0x2,%xmm6,%xmm0
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: arch/x86/tools/test_get_len found difference at 
<sha1_transform_avx>:ffffffff8108b660

Warning: ffffffff8108bfeb:	c5 c9 72 d6 1e       	vpsrld 
$0x1e,%xmm6,%xmm6
Warning: objdump says 5 bytes, but insn_get_length() says 3
Warning: decoded and checked 9508702 instructions with 48 warnings

Thanks,

	Ingo
