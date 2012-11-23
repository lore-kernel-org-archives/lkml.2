Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2KWJJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:09:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab2KWJJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:09:16 -0500
Date: Fri, 23 Nov 2012 09:09:09 +0000
From: Mel Gorman <mgorman@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/40] x86: mm: drop TLB flush from ptep_set_access_flags
Message-ID: <20121123090909.GX8218@suse.de>
References: <1353612353-1576-1-git-send-email-mgorman@suse.de>
 <1353612353-1576-3-git-send-email-mgorman@suse.de>
 <20121122205637.4e9112e2@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121122205637.4e9112e2@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 08:56:37PM +0000, Alan Cox wrote:
> On Thu, 22 Nov 2012 19:25:15 +0000
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > From: Rik van Riel <riel@redhat.com>
> > 
> > Intel has an architectural guarantee that the TLB entry causing
> > a page fault gets invalidated automatically. This means
> > we should be able to drop the local TLB invalidation.
> 
> Can we get an AMD sign off on that ?
> 

Hi Alan,

You sortof can[1]. Borislav Petkov answered that they do
https://lkml.org/lkml/2012/11/17/85 and quoted the manual at
https://lkml.org/lkml/2012/10/29/414 saying that this should be ok.

[1] There is no delicate way of putting it. I've no idea what the
    current status of current and former AMD kernel developers is.

-- 
Mel Gorman
SUSE Labs
