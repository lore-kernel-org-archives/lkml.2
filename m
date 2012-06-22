Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2FVSvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:51:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2FVSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:51:18 -0400
Date: Fri, 22 Jun 2012 11:51:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early boot panic on machine with lots of memory
Message-ID: <20120622185113.GK4642@google.com>
References: <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
 <1339667440.3321.7.camel@lappy>
 <20120618223203.GE32733@google.com>
 <1340059850.3416.3.camel@lappy>
 <20120619041154.GA28651@shangw>
 <20120619212059.GJ32733@google.com>
 <20120619212618.GK32733@google.com>
 <CAE9FiQVECyRBie-kgBETmqxPaMx24kUt1W07qAqoGD4vNus5xQ@mail.gmail.com>
 <20120621201728.GB4642@google.com>
 <CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Thu, Jun 21, 2012 at 06:47:24PM -0700, Yinghai Lu wrote:
> > I'm afraid this is too early.  We don't want the region to be unmapped
> > yet.  This should only happen after all memblock usages are finished
> > which I don't think is the case yet.
> 
> No, it is not early. at that time memblock usage is done.
> 
> Also I tested one system with huge memory, duplicated the problem on
> KVM that Sasha met.
> my patch fixes the problem.
> 
> please check attached patch.
> 
> Also I add another patch to double check if there is any reference
> with reserved.region.
> so far there is no reference found.

Thanks for checking it.  I was worried because of the re-reservation
of reserved.regions after giving memory to the page allocator -
ie. memblock_reserve_reserved_regions() call.  If memblock is done at
that point, there's no reason to have that call at all.  It could be
that that's just dead code.  If so, why aren't we freeing
memory.regions?  Also, shouldn't we be clearing
memblock.cnt/max/total_size/regions so that we know for sure that it's
never used again?  What am I missing?

Thanks.

-- 
tejun
