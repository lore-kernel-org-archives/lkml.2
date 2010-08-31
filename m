Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0HaO7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:59:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:24366 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab0HaO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,298,1280732400"; 
   d="scan'208";a="319186418"
Date: Tue, 31 Aug 2010 22:59:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
Message-ID: <20100831145922.GA32444@localhost>
References: <20100820141400.GD4636@tiehlicka.suse.cz>
 <20100822004232.GA11007@localhost>
 <20100823092246.GA25772@tiehlicka.suse.cz>
 <20100831141942.GA30353@localhost>
 <20100831143649.GA31730@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831143649.GA31730@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:36:49PM +0800, Wu Fengguang wrote:
> On Tue, Aug 31, 2010 at 10:19:42PM +0800, Wu Fengguang wrote:
> > On Mon, Aug 23, 2010 at 05:22:46PM +0800, Michal Hocko wrote:
> > > On Sun 22-08-10 08:42:32, Wu Fengguang wrote:
> > > > Hi Michal,
> > > 
> > > Hi,
> > > 
> > > > 
> > > > It helps to explain in changelog/code
> > > > 
> > > > - in what situation a ZONE_MOVABLE will contain !MIGRATE_MOVABLE
> > > >   pages? 
> > > 
> > > page can be MIGRATE_RESERVE IIUC.
> > 
> > Yup, it may also be set to MIGRATE_ISOLATE by soft_offline_page().
> 
> Ah a non-movable page allocation could fall back into the movable
> zone. See __rmqueue_fallback() and the fallbacks[][] array. So the
> 
>         if (type != MIGRATE_MOVABLE && !pageblock_free(page))
> 
> check in is_mem_section_removable() is correct. It is
> set_migratetype_isolate() that should be fixed to use the same check.

Mel, I'm not familiar with the code, but it seems that in
__rmqueue_fallback(), set_pageblock_migratetype() is not always called
after move_freepages_block() successfully moved some pages. Then it's
possible a MIGRATE_MOVABLE page block will end up containing
non-movable pages?

Thanks,
Fengguang
