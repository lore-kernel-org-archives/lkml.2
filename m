Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab0JOXlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 19:41:11 -0400
Received: from verein.lst.de ([213.95.11.210]:38058 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab0JOXlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 19:41:10 -0400
Date: Sat, 16 Oct 2010 01:40:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Ric Wheeler <rwheeler@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: Performance testing of various barrier reduction patches [was: Re: [RFC v4] ext4: Coordinate fsync requests]
Message-ID: <20101015234041.GB1035@lst.de>
References: <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com> <4CAF937C.4020500@redhat.com> <20101011202020.GF25624@tux1.beaverton.ibm.com> <20101012141455.GA27572@lst.de> <20101015233904.GG25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015233904.GG25624@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 04:39:04PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 12, 2010 at 04:14:55PM +0200, Christoph Hellwig wrote:
> > I still think adding code to every filesystem to optimize for a rather
> > stupid use case is not a good idea.  I dropped out a bit from the
> > thread in the middle, but what was the real use case for lots of
> > concurrent fsyncs on the same inode again?
> 
> The use case I'm looking at is concurrent fsyncs on /different/ inodes,
> actually.  We have _n_ different processes, each writing (and fsyncing) its own
> separate file on the same filesystem.
> 
> iirc, ext4_sync_file is called with the inode mutex held, which prevents
> concurrent fsyncs on the same inode.

Indeed.  Although we could drop it at least for the cache flush
call.  We already do this for block devices.

