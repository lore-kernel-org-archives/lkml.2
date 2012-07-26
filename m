Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2GZFAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:00:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44680 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2GZFAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:00:44 -0400
Date: Thu, 26 Jul 2012 10:29:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes: fix register_for_each_vma()->vma_address()
 check
Message-ID: <20120726045948.GC3810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120712170934.GA25455@redhat.com>
 <20120712171020.GA25500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120712171020.GA25500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072604-7606-0000-0000-0000024C02D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-12 19:10:20]:

> 1. register_for_each_vma() checks that vma_address() == vaddr but
>    this is not enough. We should also ensure that vaddr >= vm_start,
>    find_vma() guarantees "vaddr < vm_end" only.
> 
> 2. After the prevous changes, register_for_each_vma() is the only
>    reason why vma_address() has to return loff_t, all other users
>    know that we have the valid mapping at this offset and thus the
>    overflow is not possible.
> 
>    Change the code to use vaddr_to_offset() instead, imho this looks
>    more clean/understandable and now we can change vma_address().
> 
> 3. While at it, remove the unnecessary type-cast.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

