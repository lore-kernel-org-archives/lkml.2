Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1LPGa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:30:28 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:62728 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1LPGa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:30:27 -0500
Date: Fri, 16 Dec 2011 13:32:06 +0800
From: zanghongyong@huawei.com
Subject: [PATCH 0/2] vhot-net: Use kvm_memslots instead of vhost_memory to
 translate GPA to HVA
X-Originating-IP: [10.166.29.45]
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, levinsasha928@gmail.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xiaowei.yang@huawei.com, hanweidong@huawei.com, wusongwei@huawei.com,
        Hongyong Zang <zanghongyong@huawei.com>
Message-id: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0.4
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongyong Zang <zanghongyong@huawei.com>

Vhost-net uses its own vhost_memory, which results from user space (qemu) info,
to translate GPA to HVA. Since kernel's kvm structure already maintains the 
address relationship in its member *kvm_memslots*, these patches use kernel's 
kvm_memslots directly without the need of initialization and maintenance of 
vhost_memory.

Hongyong Zang (2):
  kvm: Introduce get_kvm_from_task
  vhost-net: Use kvm_memslots for address translation

 drivers/vhost/vhost.c    |   53 +++++++++++++++++----------------------------
 include/linux/kvm_host.h |    2 +-
 virt/kvm/kvm_main.c      |   13 +++++++++++
 3 files changed, 34 insertions(+), 34 deletions(-)

