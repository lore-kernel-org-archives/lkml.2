Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0HQHGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:06:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756996Ab0HQHGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:06:37 -0400
Message-ID: <4C6A33F4.2080201@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 15:02:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: [PATCH RESEND] KVM: PIT: free irq source id in handling error path
References: <4C454196.70500@cn.fujitsu.com>
In-Reply-To: <4C454196.70500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free irq source id if create pit workqueue fail

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/i8254.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 0fd6378..211716f 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -697,6 +697,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	pit->wq = create_singlethread_workqueue("kvm-pit-wq");
 	if (!pit->wq) {
 		mutex_unlock(&pit->pit_state.lock);
+		kvm_free_irq_source_id(kvm, pit->irq_source_id);
 		kfree(pit);
 		return NULL;
 	}
-- 
1.6.1.2

