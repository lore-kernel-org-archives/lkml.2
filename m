Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab0DVUHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:07:32 -0400
Received: from kroah.org ([198.145.64.141]:60140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181Ab0DVUCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:13 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:19 2010
Message-Id: <20100422195418.947945374@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sridhar Samudrala <sri@us.ibm.com>, Avi Kivity <avi@redhat.com>
Subject: [136/139] KVM: Increase NR_IOBUS_DEVS limit to 200
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sridhar Samudrala <sri@us.ibm.com>

(Cherry-picked from commit e80e2a60ff7914dae691345a976c80bbbff3ec74)

This patch increases the current hardcoded limit of NR_IOBUS_DEVS
from 6 to 200. We are hitting this limit when creating a guest with more
than 1 virtio-net device using vhost-net backend. Each virtio-net
device requires 2 such devices to service notifications from rx/tx queues.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -53,7 +53,7 @@ extern struct kmem_cache *kvm_vcpu_cache
  */
 struct kvm_io_bus {
 	int                   dev_count;
-#define NR_IOBUS_DEVS 6
+#define NR_IOBUS_DEVS 200
 	struct kvm_io_device *devs[NR_IOBUS_DEVS];
 };
 


