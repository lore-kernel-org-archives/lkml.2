Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2E2GrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:47:19 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42236 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2E2GrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:47:18 -0400
Message-ID: <4FC470C7.5040700@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:46:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 0/9] KVM: MMU: fast page fault
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052821-3568-0000-0000-000001E2D294
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
- disable fast page fault for soft mmu, let it only works for direct sptes.
- optimize spte_has_volatile_bits() and mmu_spte_update()

Performance result:
(The benchmark can be found at: http://www.spinics.net/lists/kvm/msg73011.html)

                               before            after
Run 10 times, Avg time:      532473698 ns.      195864447 ns. +63.2%

