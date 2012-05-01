Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2EAPPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:15:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2EAPPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:15:08 -0400
Message-ID: <1335885292.13683.150.camel@twins>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Date: Tue, 01 May 2012 17:14:52 +0200
In-Reply-To: <4F9FD337.5010908@redhat.com>
References: <20120427161727.27082.43096.stgit@abhimanyu>
	   <20120427162401.27082.59387.stgit@abhimanyu>
	 <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins>
	 <4F9FBF38.2060903@redhat.com> <1335869827.13683.133.camel@twins>
	 <4F9FD337.5010908@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 15:12 +0300, Avi Kivity wrote:
> 
> What's changed is not gup_fast() but the performance of munmap(),
> exit(), and exec(), no?

If it is indeed cache related like you suggested earlier, it would be
the allocation side of things, like fork()/mmap() that suffer since
there's fewer hot pages about, but yes, anything creating/destroying
page-tables.

> What bounds the amount of memory waiting to be freed during an rcu grace
> period?

Most RCU implementations don't have limits, so that could be quite a
lot. I think preemptible RCU has a batch limit at which point it tries
rather hard to force a grace period, but I'm not sure if even that
provides a hard limit.

Practically though, I haven't had reports of PPC/Sparc going funny
because of this.
