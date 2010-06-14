Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0FNPzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:55:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51624 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0FNPzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:55:38 -0400
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C164E63.2020204@redhat.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>
	 <1276214852.6437.1427.camel@nimitz>
	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>
	 <20100614084810.GT5191@balbir.in.ibm.com> <4C16233C.1040108@redhat.com>
	 <20100614125010.GU5191@balbir.in.ibm.com> <4C162846.7030303@redhat.com>
	 <1276529596.6437.7216.camel@nimitz>  <4C164E63.2020204@redhat.com>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 08:55:32 -0700
Message-Id: <1276530932.6437.7259.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 18:44 +0300, Avi Kivity wrote:
> On 06/14/2010 06:33 PM, Dave Hansen wrote:
> > At the same time, I see what you're trying to do with this.  It really
> > can be an alternative to ballooning if we do it right, since ballooning
> > would probably evict similar pages.  Although it would only work in idle
> > guests, what about a knob that the host can turn to just get the guest
> > to start running reclaim?
> 
> Isn't the knob in this proposal the balloon?  AFAICT, the idea here is 
> to change how the guest reacts to being ballooned, but the trigger 
> itself would not change.

I think the patch was made on the following assumptions:
1. Guests will keep filling their memory with relatively worthless page
   cache that they don't really need.
2. When they do this, it hurts the overall system with no real gain for
   anyone.

In the case of a ballooned guest, they _won't_ keep filling memory.  The
balloon will prevent them.  So, I guess I was just going down the path
of considering if this would be useful without ballooning in place.  To
me, it's really hard to justify _with_ ballooning in place.

> My issue is that changing the type of object being preferentially 
> reclaimed just changes the type of workload that would prematurely 
> suffer from reclaim.  In this case, workloads that use a lot of unmapped 
> pagecache would suffer.
> 
> btw, aren't /proc/sys/vm/swapiness and vfs_cache_pressure similar knobs?

Those tell you how to balance going after the different classes of
things that we can reclaim.

Again, this is useless when ballooning is being used.  But, I'm thinking
of a more general mechanism to force the system to both have MemFree
_and_ be acting as if it is under memory pressure.

Balbir, can you elaborate a bit on why you would need these patches on a
guest that is being ballooned?

-- Dave

