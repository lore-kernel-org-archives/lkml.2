Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab0FPPFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:05:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34521 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab0FPPFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:05:06 -0400
Subject: Re: [RFC][PATCH 0/9] rework KVM mmu_shrink() code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4C188D8B.40508@redhat.com>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <4C188D8B.40508@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 08:03:16 -0700
Message-Id: <1276700596.6437.16867.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 11:38 +0300, Avi Kivity wrote:
> On 06/15/2010 04:55 PM, Dave Hansen wrote:
> > These seem to boot and run fine.  I'm running about 40 VMs at
> > once, while doing "echo 3>  /proc/sys/vm/drop_caches", and
> > killing/restarting VMs constantly.
> >    
> 
> Will drop_caches actually shrink the kvm caches too?  If so we probably 
> need to add that to autotest since it's a really good stress test for 
> the mmu.

I'm completely sure.  I crashed my machines several times this way
during testing.

> > Seems to be relatively stable, and seems to keep the numbers
> > of kvm_mmu_page_header objects down.
> >    
> 
> That's no necessarily a good thing, those things are expensive to 
> recreate.  Of course, when we do need to reclaim them, that should be 
> efficient.

Oh, I meant that I didn't break the shrinker completely.

> We also do a very bad job of selecting which page to reclaim.  We need 
> to start using the accessed bit on sptes that point to shadow page 
> tables, and then look those up and reclaim unreferenced pages sooner.  
> With shadow paging there can be tons of unsync pages that are basically 
> unused and can be reclaimed at no cost to future runtime.

Sounds like a good next step.

-- Dave

