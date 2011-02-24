Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1BXJtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:49:43 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55357 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab1BXJtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:49:41 -0500
Date: Thu, 24 Feb 2011 09:49:12 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlbfs: correct handling of negative input to
	/proc/sys/vm/nr_hugepages
Message-ID: <20110224094912.GO15652@csn.ul.ie>
References: <1298303270-3184-1-git-send-email-pholasek@redhat.com> <20110222100235.GA15652@csn.ul.ie> <20110223161818.9876cc10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110223161818.9876cc10.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:18:18PM -0800, Andrew Morton wrote:
> On Tue, 22 Feb 2011 10:02:36 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Mon, Feb 21, 2011 at 04:47:49PM +0100, Petr Holasek wrote:
> > > When user insert negative value into /proc/sys/vm/nr_hugepages it will result
> > > in the setting a random number of HugePages in system (can be easily showed
> > > at /proc/meminfo output).
> > 
> > I bet you a shiny penny that the value of HugePages becomes the maximum
> > number that could be allocated by the system at the time rather than a
> > random value.
> 
> That seems to be the case from my reading.  In which case the patch
> removes probably-undocumented and possibly-useful existing behavior.
> 

It's not proof that no one does this but I'm not aware of any documentation
related to hugetlbfs that recommends writing negative values to take advantage
of this side-effect. It's more likely they simply wrote a very large number
to nr_hugepages if they wanted "as many hugepages as possible" as it makes
more intuitive sense than asking for a negative amount of pages. hugeadm at
least is not depending on this behaviour AFAIK.

-- 
Mel Gorman
SUSE Labs
