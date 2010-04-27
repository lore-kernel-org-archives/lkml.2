Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab0D0FtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:49:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46024 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0D0FtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:49:21 -0400
Date: Tue, 27 Apr 2010 15:49:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100427154917.405e21df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/kvm/book3s.c: In function 'kvmppc_core_vcpu_create':
arch/powerpc/kvm/book3s.c:1241: error: implicit declaration of function 'kzalloc'
arch/powerpc/kvm/book3s.c:1241: warning: cast to pointer from integer of different size
arch/powerpc/kvm/book3s.c:1281: error: implicit declaration of function 'kfree'

Caused by commit 046cdc052ffcbf1ee1c627ef811031d18654bafe ("KVM: PPC:
Improve indirect svcpu accessors") from the kvm tree.

You have to include slab.h directly to use kzalloc/kfree ...

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 Apr 2010 15:32:53 +1000
Subject: [PATCH] kvm: powerpc: use of kzalloc/kfree requires including slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kvm/book3s.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 9f97dbe..28e785f 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -16,6 +16,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #include <asm/reg.h>
 #include <asm/cputable.h>
-- 
1.7.0.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
