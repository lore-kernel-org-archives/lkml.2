Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2CENK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:10:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab2CENKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:10:55 -0500
Date: Mon, 5 Mar 2012 14:10:53 +0100
From: Jan Kara <jack@suse.cz>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>,
        Jacek Luczak <difrost.kernel@gmail.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120305131053.GH6643@quack.suse.cz>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
 <20120302140038.GD5054@shiny>
 <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
 <20120302142651.GH5054@shiny>
 <20120302193215.GB22215@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302193215.GB22215@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-03-12 14:32:15, Ted Tso wrote:
> On Fri, Mar 02, 2012 at 09:26:51AM -0500, Chris Mason wrote:
> It would be interesting to have a project where someone added
> fallocate() support into libelf, and then added some hueristics into
> ext4 so that if a file is fallocated to a precise size, or if the file
> is fully written and closed before writeback begins, that we use this
> to more efficiently pack the space used by the files by the block
> allocator.  This is a place where I would not be surprised that XFS
> has some better code to avoid accelerated file system aging, and where
> we could do better with ext4 with some development effort.
  AFAIK XFS people actually prefer that applications let them do their work
using delayed allocation and do not interfere with fallocate(2) calls. The
problem they have with fallocate(2) is that it forces you to allocate
blocks while with delayed allocation you can make the decision about
allocation later. So for small files which completely fit into pagecache
before they get pushed out by writeback, they can make better decisions
from delayed allocation. Just dumping my memory from some other thread...

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
