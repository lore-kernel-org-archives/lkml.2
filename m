Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2IOPlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2IOPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:41:44 -0400
Date: Sat, 15 Sep 2012 12:31:06 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
Message-ID: <20120915153106.GC3037@amt.cnet>
References: <5052FF61.3070600@linux.vnet.ibm.com>
 <5053000E.3050303@linux.vnet.ibm.com>
 <50530337.2080208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50530337.2080208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:13:11PM +0800, Xiao Guangrong wrote:
> On 09/14/2012 05:59 PM, Xiao Guangrong wrote:
> 
> > +		return FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true);
> 
> Sorry, this was wrong. Update this patch.
> 
> [PATCH v2 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
> 
> The only different thing between FNAME(update_pte) and FNAME(pte_prefetch)
> is that the former is allowed to prefetch gfn from dirty logged slot, so
> introduce a common function to prefetch spte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

IMHO, for the human reader, the meaning of the two functions is
different and therefore separation is justified. Moreover they already
share common code via FNAME(prefetch_invalid_gpte) (which BTW, is a
confusing name because the function does not prefetch gpte, it validates
gpte).

