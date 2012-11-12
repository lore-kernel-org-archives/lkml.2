Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2KLXKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:10:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2KLXKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:10:42 -0500
Date: Mon, 12 Nov 2012 21:10:32 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: lazily drop large spte
Message-ID: <20121112231032.GB5798@amt.cnet>
References: <50978DFE.1000005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50978DFE.1000005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 05:59:26PM +0800, Xiao Guangrong wrote:
> Do not drop large spte until it can be insteaded by small pages so that
> the guest can happliy read memory through it
> 
> The idea is from Avi:
> | As I mentioned before, write-protecting a large spte is a good idea,
> | since it moves some work from protect-time to fault-time, so it reduces
> | jitter.  This removes the need for the return value.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   34 +++++++++-------------------------
>  1 files changed, 9 insertions(+), 25 deletions(-)

Its likely that other 4k pages are mapped read-write in the 2mb range 
covered by a read-only 2mb map. Therefore its not entirely useful to
map read-only. 

Can you measure an improvement with this change?


