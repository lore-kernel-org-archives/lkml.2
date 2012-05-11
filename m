Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2EKHnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab2EKHno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:43:44 -0400
Date: Fri, 11 May 2012 10:43:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Anthony Liguori <aliguori@us.ibm.com>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] qemu: whitelist kvm pv eoi feature
Message-ID: <20120511074334.GA1504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336679924.git.mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitelist kvm pv eoi feature. The feature is enabled
with -cpu kvm64. To disable: -cpu kvm64,-kvm_eoi.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Sending a copy to kernel list as this is needed
to test the pv eoi feature recently submitted.

 target-i386/cpuid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/target-i386/cpuid.c b/target-i386/cpuid.c
index 465ea15..c421b19 100644
--- a/target-i386/cpuid.c
+++ b/target-i386/cpuid.c
@@ -75,7 +75,7 @@ static const char *ext3_feature_name[] = {
 };
 
 static const char *kvm_feature_name[] = {
-    "kvmclock", "kvm_nopiodelay", "kvm_mmu", "kvmclock", "kvm_asyncpf", NULL, NULL, NULL,
+    "kvmclock", "kvm_nopiodelay", "kvm_mmu", "kvmclock", "kvm_asyncpf", NULL, "kvm_eoi", NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-- 
MST
