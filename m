Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1IRBqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 21:46:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:32805 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab1IRBqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 21:46:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,399,1312182000"; 
   d="scan'208";a="49979151"
Date: Sat, 17 Sep 2011 18:46:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "jeff.liu@oracle.com" <jeff.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Message-ID: <20110918014608.GA16198@alboin.amr.corp.intel.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <1316128013-21980-2-git-send-email-andi@firstfloor.org>
 <20110916154815.GA27150@infradead.org>
 <4E7439EB.7080100@oracle.com>
 <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > with an additional improvement if the offset is larger or equal to the
> > file size, return -ENXIO in directly:
> > 
> >                if (offset >= inode->i_size) {
> >                        mutex_unlock(&inode->i_mutex);
> >                        return -ENXIO;
> >                }
> 
> Except that is wrong, because it would then be impossible to write sparse files. 

And also i_size must be always read with i_size_read()

Anyways clearly there's a problem in btrfs land with merging fixes in time.
Is anyone collecting patches while Chris is gone?

-Andi

