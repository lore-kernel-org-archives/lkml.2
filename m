Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2AaTEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:04:32 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55586
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab2AaTEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:04:30 -0500
Date: Tue, 31 Jan 2012 14:04:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Niels de Vos <ndevos@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device if
 fsync() is called for a partition
Message-ID: <20120131190425.GA10533@infradead.org>
References: <4F213E1A.4060808@redhat.com>
 <1327584802-14298-1-git-send-email-ndevos@redhat.com>
 <20120126134051.6add3cd2.akpm@linux-foundation.org>
 <20120126214534.GA9319@infradead.org>
 <4F28102C.1070207@redhat.com>
 <20120131105824.c48351b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131105824.c48351b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:58:24AM -0800, Andrew Morton wrote:
> One concern I have with the proposal is that it would forever rule out
> support of >16T devices on 32-bit machines.
> 
> At present with 64-bit sector_t and 32-bit pgoff_t, I think we'd have a
> reasonable chance of supporting, say, four 8T partitions on a 32T
> device.  But if we were to switch the kernel from using four 4T
> address_spaces (sda1-4) over to using a single 32T address_space (sda)
> then we can rule it all out.

how do you plan to write the partition label in your hypothetic setup
if you can't open the main device?

And even if we solved that and people could create partitions on these
devices but not open the main device, or use large lvm volumes it would
be an absolutely major confusion.

So I really don't think your made up case matters.
