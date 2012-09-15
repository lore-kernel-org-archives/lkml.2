Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2IOPm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:42:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2IOPmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:42:24 -0400
Date: Sat, 15 Sep 2012 12:25:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: MMU: introduce page_fault_start and
 page_fault_end
Message-ID: <20120915152512.GB3037@amt.cnet>
References: <5052FF61.3070600@linux.vnet.ibm.com>
 <5052FFEA.1040607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052FFEA.1040607@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 05:59:06PM +0800, Xiao Guangrong wrote:
> Wrap the common operations into these two functions
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Why? I think people are used to 

spin_lock(lock)
sequence
spin_unlock(lock)

So its easy to verify whether access to data structures are protected.

Unrelated to this patch, one opportunity i see to simplify this
code is:

- error pfn / mmio pfn / invalid pfn relation

Have the meaning of this bits unified in a single function/helper, see
comment to patch 1 (perhaps you can further improve).

