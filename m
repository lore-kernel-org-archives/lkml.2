Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2HGJrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:47:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33507 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2HGJrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:47:39 -0400
Message-ID: <5020E423.9080004@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:47:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 00/12] KVM: introduce readonly memslot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-4790-0000-0000-00000406FE76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
- introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
- introduce KVM_HVA_ERR_BAD and optimize error hva indicators

The test case can be found at:
http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2

In current code, if we map a readonly memory space from host to guest
and the page is not currently mapped in the host, we will get a fault-pfn
and async is not allowed, then the vm will crash.

As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
to the guest, read access is happy for readonly memslot, write access on
readonly memslot will cause KVM_EXIT_MMIO exit.

