Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2AaThw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:37:52 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55722
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056Ab2AaThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:37:51 -0500
Date: Tue, 31 Jan 2012 14:37:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Niels de Vos <ndevos@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device if
 fsync() is called for a partition
Message-ID: <20120131193748.GA10093@infradead.org>
References: <4F213E1A.4060808@redhat.com>
 <1327584802-14298-1-git-send-email-ndevos@redhat.com>
 <20120126134051.6add3cd2.akpm@linux-foundation.org>
 <20120126214534.GA9319@infradead.org>
 <4F28102C.1070207@redhat.com>
 <20120131105824.c48351b6.akpm@linux-foundation.org>
 <20120131190425.GA10533@infradead.org>
 <20120131113250.816ee772.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131113250.816ee772.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 11:32:50AM -0800, Andrew Morton wrote:
> I didn't say the kernel would support this as-is.
> 
> If the partitioning scheme requires writing to the individual
> partitions then something would need to be done, such as a simple
> offsetting DM driver.

Writing partition tables requires writing to them main block device.

Seriously - if people want to support block devices nodes > 16TB dealing
with this isn't the problem.  They'll need to find a way to do buffered
I/O without using the pagecache to get it right, at which point
blkdev_get_block in either form will simply go away.
