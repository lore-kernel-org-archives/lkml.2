Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1GGIwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1GGIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:51:28 -0400
Date: Thu, 7 Jul 2011 05:16:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 14/19] KVM: MMU: clean up spte updating and clearing
Message-ID: <20110707081621.GB8334@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C32FE.2020805@cn.fujitsu.com>
 <20110706173911.GA9820@amt.cnet>
 <4E14B511.5000408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14B511.5000408@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:18:41AM +0800, Xiao Guangrong wrote:
> On 07/07/2011 01:39 AM, Marcelo Tosatti wrote:
>  
> >> -static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
> >> +static void track_spte_bits(u64 old_spte, u64 keep_bits, bool always_track)
> >>  {
> >> -	return (old_spte & bit_mask) && !(new_spte & bit_mask);
> >> +	if (always_track ||
> >> +	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_accessed_mask)))
> >> +		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> >> +
> >> +	if (always_track ||
> >> +	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_dirty_mask)))
> >> +		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> >> +}
> > 
> > This is much more confusing than previously, please drop it.
> > 
> 
> What about remove "always_track" parameter? After that, the code should be clear.

Its easier to read by having it opencoded as it is now.

