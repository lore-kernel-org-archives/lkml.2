Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1K3AY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:24:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:52675 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab1K3AY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:24:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,594,1315206000"; 
   d="scan'208";a="80429690"
Date: Wed, 30 Nov 2011 08:24:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "Li, Shaohua" <shaohua.li@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] readahead: basic support for backwards prefetching
Message-ID: <20111130002425.GA8734@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.925952168@intel.com>
 <20111129153552.GP5635@quack.suse.cz>
 <4ED50A63.1010805@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ED50A63.1010805@draigBrady.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:37:55AM +0800, Pádraig Brady wrote:
> On 11/29/2011 03:35 PM, Jan Kara wrote:
> >   Someone already mentioned this earlier and I don't think I've seen a
> > response: Do you have a realistic usecase for this? I don't think I've ever
> > seen an application reading file backwards...
> 
> tac, tail -n$large, ...

Indeed!
             tac-4425  [000] 73358.419777: readahead: readahead-random(dev=0:16, ino=1548445, req=750+1, ra=750+1-0, async=0) = 1
             tac-4425  [004] 73358.442030: readahead: readahead-backwards(dev=0:16, ino=1548445, req=748+2, ra=746+5-0, async=0) = 4
             tac-4425  [004] 73358.443312: readahead: readahead-backwards(dev=0:16, ino=1548445, req=744+2, ra=726+25-0, async=0) = 20

            tail-4369  [000] 72633.696307: readahead: readahead-random(dev=0:16, ino=1548450, req=750+1, ra=750+1-0, async=0) = 1
            tail-4369  [004] 72634.042106: readahead: readahead-backwards(dev=0:16, ino=1548450, req=748+2, ra=746+5-0, async=0) = 4
            tail-4369  [004] 72634.043231: readahead: readahead-backwards(dev=0:16, ino=1548450, req=744+2, ra=726+25-0, async=0) = 20
            tail-4369  [004] 72634.176216: readahead: readahead-backwards(dev=0:16, ino=1548450, req=724+2, ra=626+125-0, async=0) = 100

However I see the readahead requests always be snapped to EOF.

So it's obvious the "snap to EOF" logic need some limiting based on
max readahead size.

Thanks,
Fengguang
