Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1HZKx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:53:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1HZKxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:53:53 -0400
Date: Fri, 26 Aug 2011 07:53:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110826105328.GA12612@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1257.5080204@cn.fujitsu.com>
 <20110823080024.GA2297@amt.cnet>
 <4E53872B.3070407@cn.fujitsu.com>
 <20110823123818.GB4261@amt.cnet>
 <4E53D620.9030304@cn.fujitsu.com>
 <20110823190939.GA10220@amt.cnet>
 <4E560062.40805@cn.fujitsu.com>
 <20110825134712.GB4384@amt.cnet>
 <4E571069.2050701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E571069.2050701@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:18:01AM +0800, Xiao Guangrong wrote:
> On 08/25/2011 09:47 PM, Marcelo Tosatti wrote:
> 
> > I guess it is OK to be more trigger happy with zapping by ignoring
> > the accessed bit, clearing the flood counter on page fault.
> > 
> 
> Yeah, i like this way, is this patch good for you?

Looks fine, can you rerun kernbench?

> ================================
> Subject: [PATCH 11/11] KVM: MMU: improve write flooding detected
> 
> Detecting write-flooding does not work well, when we handle page written, if
> the last speculative spte is not accessed, we treat the page is
> write-flooding, however, we can speculative spte on many path, such as pte
> prefetch, page synced, that means the last speculative spte may be not point
> to the written page and the written page can be accessed via other sptes, so
> depends on the Accessed bit of the last speculative spte is not enough
> 
> Instead of detected page accessed, we can detect whether the spte is accessed
> after it is written, if the spte is not accessed but it is written frequently,
> we treat is not a page table or it not used for a long time
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
