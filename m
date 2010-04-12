Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab0DLBfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 21:35:00 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:51751 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0DLBe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 21:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mNwjcalNZDCtW99bR1GgAsLaAsDYdj59cRcZKyu4cGZkLRkb5026kI+8Wgvmp0v/Mc
         K2vR9Jt0NrCDHB4woCw55yBJaVhctARmcd6Vp62DJW79u3KLlrrAxGBXlb3C6q47zUtJ
         81awSu0H4TOMmGE6OiQ9mgFOIYGyAFgt3bBkY=
Date: Mon, 12 Apr 2010 17:34:52 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: remove unused code in kvm_coalesced_mmio_init()
Message-ID: <20100412093452.GB2707@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret is already set as ENOMEM before, so the second ret = -ENOMEM; can be removed.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 virt/kvm/coalesced_mmio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5169736..c0dcfb7 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -101,7 +101,6 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 		goto out_err;
 	kvm->coalesced_mmio_ring = page_address(page);
 
-	ret = -ENOMEM;
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
 		goto out_free_page;
-- 
1.6.5.3

