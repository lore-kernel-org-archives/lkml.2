Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0H3BFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:05:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:1408 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab0H3BFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,289,1280732400"; 
   d="scan'208";a="833014553"
Subject: Re: [RFC v2 PATCH 0/6] Btrfs: Add hot data relocation functionality
From: Shaohua Li <shaohua.li@intel.com>
To: Hubert Kario <hka@qbs.com.pl>
Cc: "bchociej@gmail.com" <bchociej@gmail.com>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmm@us.ibm.com" <cmm@us.ibm.com>,
        "bcchocie@us.ibm.com" <bcchocie@us.ibm.com>,
        "mrlupfer@us.ibm.com" <mrlupfer@us.ibm.com>,
        "crscott@us.ibm.com" <crscott@us.ibm.com>,
        "mlupfer@gmail.com" <mlupfer@gmail.com>,
        "conscott@vt.edu" <conscott@vt.edu>
In-Reply-To: <201008300242.27331.hka@qbs.com.pl>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
	 <20100826021343.GA452@sli10-conroe.sh.intel.com>
	 <201008300242.27331.hka@qbs.com.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 09:05:29 +0800
Message-ID: <1283130329.16633.2.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 08:42 +0800, Hubert Kario wrote:
> On Thursday 26 of August 2010 04:13:43 Shaohua Li wrote:
> > On Fri, Aug 13, 2010 at 06:22:00AM +0800, bchociej@gmail.com wrote:
> > > - Hooks in existing Btrfs functions to track data access frequency
> > > 
> > >   (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)
> > > 
> > > - New rbtrees for tracking access frequency of inodes and sub-file
> > > 
> > >   ranges (hotdata_map.c)
> > > 
> > > - A hash list for indexing data by its temperature (hotdata_hash.c)
> > > 
> > > - A debugfs interface for dumping data from the rbtrees (debugfs.c)
> > > 
> > > - A background kthread for relocating data to faster media based on
> > > 
> > >   temperature
> > 
> > Hi,
> > I'm wondering if the temperature info can be exported to userspace, and
> > let a daemon to do the relocation (by ioctl). A userspace daemon is more
> > flexible.
> 
> Flexibility of userspace daemon is one thing, the ability to let the admin 
> precisely control on which drive data is placed could be really beneficial in 
> some scenarios is another thing.
> 
> This would also allow online defragmentation, together with access to 
> statistics, one that (for quick runs) has really good time/performance benefit 
> ratio.
Agreed, I'm thinking of the online defragmentation based on hot access
too. Btrfs usually has more fragment.

