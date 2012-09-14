Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2INJ5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:57:03 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59863 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2INJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:57:00 -0400
Message-ID: <5052FF61.3070600@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:56:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 0/5] KVM: MMU: fix release pfn in mmu code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091409-9574-0000-0000-0000046A3530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release pfn in the mmu code is little special for we allow no-slot pfn
go to spte walk on page fault path, that means, on page fault fail path,
we can not directly call kvm_release_pfn_clean.

This patchset fixes the bug which release no-slot pfn on fail path and
clean up all the paths where kvm_release_pfn_clean is called

