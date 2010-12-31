Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0LaCz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 21:55:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44644 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0LaCzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 21:55:47 -0500
Date: Fri, 31 Dec 2010 13:55:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20101231135546.73f318bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/x86/kernel/apic/x2apic_uv_x.c between commit
d8850ba425d9823d3184bd52f065899dac4689f9 ("x86, UV: Fix the effect of
extra bits in the hub nodeid register") from the tip tree and commit
0a3aee0da4402aa19b66e458038533c896fb80c6 ("x86: Use this_cpu_ops to
optimize code") from the percpu tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/apic/x2apic_uv_x.c
index 2a3f2a7,26ec9a7..0000000
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@@ -120,8 -118,8 +120,8 @@@ static int __init uv_acpi_madt_oem_chec
  		else if (!strcmp(oem_table_id, "UVX"))
  			uv_system_type = UV_X2APIC;
  		else if (!strcmp(oem_table_id, "UVH")) {
- 			__get_cpu_var(x2apic_extra_bits) =
- 				pnodeid << uvh_apicid.s.pnode_shift;
+ 			__this_cpu_write(x2apic_extra_bits,
 -				nodeid << (uvh_apicid.s.pnode_shift - 1));
++				pnodeid << uvh_apicid.s.pnode_shift);
  			uv_system_type = UV_NON_UNIQUE_APIC;
  			uv_set_apicid_hibit();
  			return 1;
