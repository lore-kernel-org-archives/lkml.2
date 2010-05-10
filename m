Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab0EJXNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:13:21 -0400
Received: from kroah.org ([198.145.64.141]:51821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911Ab0EJW6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:21 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.612507073@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kvm <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [69/98] KVM: remove unused load_segment_descriptor_to_kvm_desct
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

Commit 78ce64a384 in v2.6.32.12 introduced a warning due to unused
load_segment_descriptor_to_kvm_desct helper, which has been opencoded by
this commit.

On upstream, the helper was removed as part of a different commit.

Remove the now unused function.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4155,18 +4155,6 @@ static u16 get_segment_selector(struct k
 	return kvm_seg.selector;
 }
 
-static int load_segment_descriptor_to_kvm_desct(struct kvm_vcpu *vcpu,
-						u16 selector,
-						struct kvm_segment *kvm_seg)
-{
-	struct desc_struct seg_desc;
-
-	if (load_guest_segment_descriptor(vcpu, selector, &seg_desc))
-		return 1;
-	seg_desct_to_kvm_desct(&seg_desc, selector, kvm_seg);
-	return 0;
-}
-
 static int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int seg)
 {
 	struct kvm_segment segvar = {


