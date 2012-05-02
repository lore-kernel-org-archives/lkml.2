Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2EBNyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:54:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35140 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EBNyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:54:05 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, mingo@elte.hu, jeremy@goop.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <1335954040.13683.175.camel@twins>
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com> <1335865176.13683.120.camel@twins> <87obq7ge4d.fsf@linux.vnet.ibm.com> <1335954040.13683.175.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Wed, 02 May 2012 19:23:26 +0530
Message-ID: <87lilahep5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12050213-2000-0000-0000-000007524104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 12:20:40 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-05-02 at 14:21 +0530, Nikunj A Dadhania wrote:
> > [root@krm1 linux]# grep HAVE_RCU_TABLE .config
> > CONFIG_HAVE_RCU_TABLE_FREE=y
> > [root@krm1 linux]# make -j32  -s
> > mm/memory.c: In function ‘tlb_remove_table_one’:
> > mm/memory.c:315: error: implicit declaration of function ‘__tlb_remove_table’
> > 
> > I suppose we need to have __tlb_remove_table. Trying to understand what
> > needs to be done there. 
> 
> Argh, I really should get back to unifying all mmu-gather
> implementations :/
> 
> I think something like the below ought to sort it.
> 
Thanks a lot.

> Completely untested though..
> 

Tested-by: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>

Here is the comparison with the other version. 

	Gang    pv_spin_flush    pv_spin_flush_rcu  
1VM     1.01       0.49            0.49     
2VMs    7.07       4.04            4.06     
4VMs    9.07       5.27            5.19     
8VMs    9.99       7.65            7.80     

Will test other use cases as well and report back.

Regards
Nikunj

