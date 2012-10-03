Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2JCMMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:12:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:3726 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2JCMLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:11:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="scan'208";a="151907426"
Date: Wed, 3 Oct 2012 05:11:32 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, x86@vger.kernel.org, eranian@google.com,
        jolsa@redhat.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 06/31] perf, kvm: Support the intx/intx_cp modifiers in
 KVM arch perfmon emulation
Message-ID: <20121003121132.GG2628@tassilo.jf.intel.com>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
 <1349221731-15665-7-git-send-email-andi@firstfloor.org>
 <506C131A.1070600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C131A.1070600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -			eventsel & ARCH_PERFMON_EVENTSEL_INT);
> > +			eventsel & ARCH_PERFMON_EVENTSEL_INT,
> > +			!!(eventsel & HSW_INTX),
> > +			!!(eventsel & HSW_INTX_CHECKPOINTED));
> >  }
> >  
> 
> Those !! are !necessary, since the formal argument is a bool.

bool is 1 or 0, x & y with y > 1 is not 1 or 0.
iirc assigning > 1 to bool is undefined

So I think they are necessary.

Or did I misundersand you?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
