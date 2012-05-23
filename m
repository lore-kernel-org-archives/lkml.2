Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2EWGcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:32:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36820 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2EWGcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:32:45 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Subject: [RFC] kvm: export host NUMA info to guest's scheduler
Date: Wed, 23 May 2012 14:32:27 +0800
Message-Id: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the guest can not know the NUMA info of the vcpu, which will
result in performance drawback. For example:
  Supposing vcpu-a on nodeA, vcpu-b on nodeB, when load balance,
the tasks' pull and push between these vcpus will cost more. But
unfortunately, currently, the guest is just blind to this.

So here is the idea to solve it.
  Export host numa info through guest's sched domain to its scheduler.
  So the guest's lb will consider the cost.

These patches include:
For guest:
  0001-sched-add-virt-sched-domain-for-the-guest.patch
  0002-sched-add-virt-domain-device-s-driver.patch
For host:
  0001-kvm-collect-vcpus-numa-info-for-guest-s-scheduler.patch  
  0001-Qemu-add-virt-sched-domain-device.patch


Please give some comments and suggestion.

Thanks and regards,
pingfan

