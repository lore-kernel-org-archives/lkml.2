Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1KULfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:35:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:55165 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab1KULfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:35:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,546,1315206000"; 
   d="scan'208";a="77510414"
Date: Mon, 21 Nov 2011 19:35:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ankit Jain <radical@gmail.com>, Dave Chinner <david@fromorbit.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/8] readahead: make default readahead size a kernel
 parameter
Message-ID: <20111121113540.GB8895@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.251104145@intel.com>
 <20111121100137.GC5084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121100137.GC5084@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 06:01:37PM +0800, Christoph Hellwig wrote:
> On Mon, Nov 21, 2011 at 05:18:21PM +0800, Wu Fengguang wrote:
> > From: Nikanth Karthikesan <knikanth@suse.de>
> > 
> > Add new kernel parameter "readahead=", which allows user to override
> > the static VM_MAX_READAHEAD=128kb.
> 
> Is a boot-time paramter really such a good idea?  I would at least

It's most convenient to set at boot time, because the default size
will be used to initialize all the block devices.

> make it a sysctl so that it's run-time controllable, including
> beeing able to set it from initscripts.

Once boot up, it's more natural to set the size one by one, for
example

        blockdev --setra 1024 /dev/sda2
or
        echo 512 > /sys/block/sda/queue/read_ahead_kb

And you still have the chance to modify the global default, but the
change will only be inherited by newly created devices thereafter:

        echo 512 > /sys/devices/virtual/bdi/default/read_ahead_kb

The above command is very suitable for use in initscripts.  However
there are no natural way to do sysctl as there is no such a global
value.

Thanks,
Fengguang
