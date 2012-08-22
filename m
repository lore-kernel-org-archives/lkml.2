Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab2HVENC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:13:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59774 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2HVEM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:12:57 -0400
Date: Tue, 21 Aug 2012 21:12:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between
 secondary MMU and host
In-Reply-To: <50345735.2000807@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.00.1208212105370.3415@eggly.anvils>
References: <503358FF.3030009@linux.vnet.ibm.com> <20120821150618.GJ27696@redhat.com> <50345735.2000807@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Xiao Guangrong wrote:
> On 08/21/2012 11:06 PM, Andrea Arcangeli wrote:
> > 
> > The KSM usage of it looks safe because it will only establish readonly
> > ptes with it.
> 
> Hmm, in KSM code, i found this code in replace_page:
> 
> set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
> 
> It is possible to establish a writable pte, no?

No: we only do KSM in private vmas (!VM_SHARED), and because of the
need to CopyOnWrite in those, vm_page_prot excludes write permission:
write permission has to be added on COW fault.

Hugh
