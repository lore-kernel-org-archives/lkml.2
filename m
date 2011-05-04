Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1EDSrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:47:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1EDSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:47:03 -0400
Date: Wed, 4 May 2011 14:46:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] data integrity: Stabilize pages during writeback
 for ext4
Message-ID: <20110504184644.GA23246@infradead.org>
References: <20110406232938.GF1110@tux1.beaverton.ibm.com>
 <20110407165700.GB7363@quack.suse.cz>
 <20110408203135.GH1110@tux1.beaverton.ibm.com>
 <20110411124229.47bc28f6@corrin.poochiereds.net>
 <1302543595-sup-4352@think>
 <1302569212.2580.13.camel@mingming-laptop>
 <20110412005719.GA23077@infradead.org>
 <1302742128.2586.274.camel@mingming-laptop>
 <20110422000226.GA22189@tux1.beaverton.ibm.com>
 <20110504173704.GE20579@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504173704.GE20579@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to miss out on a lot of the generic functionality like
write_cache_pages and block_page_mkwrite and just patch it into
the ext4 copy & paste variants.  Please make sure your patches also
work for filesystem that use more of the generic functionality like
xfs or ext2 (the latter one might be fun for the mmap case).

Also what's the status of btrfs?  I remembered there was one or two
bits missing despite doing the right thing in most areas.
