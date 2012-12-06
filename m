Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab2LFVpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:45:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145Ab2LFVo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:44:59 -0500
Subject: [PATCH] kvm: Fix irqfd resampler list walk
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 06 Dec 2012 14:44:59 -0700
Message-ID: <20121206214355.24853.71852.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo for the next pointer means we're walking random data here.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org [3.7]
---

Not sure if this will make 3.7, so preemptively adding the stable flag

 virt/kvm/eventfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 9718e98..62e7bd6 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -332,7 +332,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		mutex_lock(&kvm->irqfds.resampler_lock);
 
 		list_for_each_entry(resampler,
-				    &kvm->irqfds.resampler_list, list) {
+				    &kvm->irqfds.resampler_list, link) {
 			if (resampler->notifier.gsi == irqfd->gsi) {
 				irqfd->resampler = resampler;
 				break;

