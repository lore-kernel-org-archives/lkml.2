Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2IUG4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:56:50 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55387 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2IUG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:56:48 -0400
Message-ID: <505C0FA8.5070007@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 14:56:40 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 0/7] KVM: MMU: fix release pfn in mmu code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092106-9574-0000-0000-00000485357E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
changes from Avi's comments:
 - comment for FNAME(fetch)
 - add annotations (__acquires, __releases) for page_fault_start and
   page_fault_end

changes from Marcelo's comments:
 - remove mmu_is_invalid
 - make release noslot pfn path more readable

The last patch which introduces page_fault_start and page_fault_end is
controversial, i hope we can try it since it wrap the ugly pfn release
path up, but i respect your idea. :)

Release pfn in the mmu code is little special for we allow no-slot pfn
go to spte walk on page fault path, that means, on page fault fail path,
we can not directly call kvm_release_pfn_clean.

This patchset fixes the bug which release no-slot pfn on fail path and
clean up all the paths where kvm_release_pfn_clean is called

