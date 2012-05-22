Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2EVQhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:37:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:31311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab2EVQhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:37:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="143382469"
Date: Tue, 22 May 2012 09:37:35 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, cl@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mgorman@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@vger.kernel.org
Subject: Re: unnecessary tlb flush in mprotect
Message-ID: <20120522163735.GB1906@tassilo.jf.intel.com>
References: <4FB9FD1D.6000001@intel.com>
 <4FBAE71F.5000801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBAE71F.5000801@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 09:08:47AM +0800, Alex Shi wrote:
> On 05/21/2012 04:30 PM, Alex Shi wrote:
> 
> > when mprotect just change prots of non-present pages, current mprotect
> > still do the tlb flush in check_protection().
> > but according to 4.10.2.3 Intel SDM V3A (
> > www.intel.com/Assets/ja_JP/PDF/manual/253668.pdf ) at that time, TLB has
> > no this lines for this page. So, tlb flush is just waste time. (for cr3
> > rewrite, flush all tlb, or invlpg, like a 'nop' in intel cpu)
> > 
> > Do we need to add the pte_present similar check here to prevent the
> > unnecessary tlb flushing? I mean, are there real case in word, User like
> > to change page prots before assign a physical page to it?
> > 
> 
> 
> Any comments from linux-mm emailing list?

I would be careful with TLB optimizations if it's not a clear performance
wins. A lot of these interactions are tricky and it's very easy to break
things in subtle and hard to debug ways.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
