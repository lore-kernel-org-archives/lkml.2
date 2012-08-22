Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2HVGaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:30:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:28097 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab2HVGaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="183705291"
Date: Wed, 22 Aug 2012 14:31:00 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Li Shaohua <shli@fusionio.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
        "Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
        linux RAID <linux-raid@vger.kernel.org>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Message-ID: <20120822063100.GH2570@yliu-dev.sh.intel.com>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
 <20120817134039.GB11439@thunk.org>
 <20120817142526.GA1059@localhost>
 <20120822035702.GF2570@yliu-dev.sh.intel.com>
 <20120822160025.272188d1@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822160025.272188d1@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:00:25PM +1000, NeilBrown wrote:
> On Wed, 22 Aug 2012 11:57:02 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> >  
> > -#define NR_STRIPES		256
> > +#define NR_STRIPES		1024
> 
> Changing one magic number into another magic number might help your case, but
> it not really a general solution.

Agreed.

> 
> Possibly making sure that max_nr_stripes is at least some multiple of the
> chunk size might make sense, but I wouldn't want to see a very large multiple.
> 
> I thing the problems with RAID5 are deeper than that.  Hopefully I'll figure
> out exactly what the best fix is soon - I'm trying to look into it.
> 
> I don't think the size of the cache is a big part of the solution.  I think
> correct scheduling of IO is the real answer.

Yes, it should not be. But with less max_nr_stripes, the chance to get a
full strip write is less, and maybe that's the reason why the chance to
block at get_active_strip() is more; and also, the reading is more.

The perfect case would be there are no reading; setting max_nr_stripes
to 32768(the max we get set now), you will find the reading is quite
less(almost zero, please see the iostat I attached in former email).

Anyway, I do agree this should not be the big part of the solution. If
we can handle those stripes faster, I guess 256 would be enough.

Thanks,
Yuanhan Liu
