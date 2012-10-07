Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2JGMAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 08:00:48 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35021 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2JGMAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 08:00:41 -0400
Message-ID: <50716EE0.6010504@linux.vnet.ibm.com>
Date: Sun, 07 Oct 2012 20:00:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 0/5] KVM: MMU: fix release no-slot pfn and clean up mmu
 code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12100711-9264-0000-0000-000002755146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
- filter error pfn out in the common function - kvm_release_pfn instead
  of doing it in mmu code
- remove the patches which clean up for release noslot pfn path

Release pfn in the mmu code is little special for we allow no-slot pfn
go to spte walk on page fault path, that means, on page fault fail path,
we can not directly call kvm_release_pfn_clean.

This patchset fixes the bug which adds a branch to filter error pfn out
in kvm_release_pfn_clean and clean up current mmu code.

