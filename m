Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2FTH4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:56:38 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56257 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2FTH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:56:37 -0400
Message-ID: <4FE1822D.8010002@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 15:56:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v7 00/10] KVM: MMU: fast page fault
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062007-2674-0000-0000-000004F5C044
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
- always atomicly update the spte if it can be updated out of mmu-lock
- rename spte_can_be_writable() to spte_is_locklessly_modifiable()
- cleanup and comment spte_write_protect()

Performance result:
(The benchmark can be found at: http://www.spinics.net/lists/kvm/msg73011.html)

                               before            after
Run 10 times, Avg time:      538233957 ns.      249809853 ns. +53.6%

