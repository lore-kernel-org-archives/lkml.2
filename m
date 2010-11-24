Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0KXMrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:47:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:42097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0KXMrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:47:22 -0500
Subject: Re: [PATCH 08/13] writeback: quit throttling when bdi dirty pages
 dropped low
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101124123023.GA10413@localhost>
References: <20101117042720.033773013@intel.com>
	 <20101117042850.245782303@intel.com> <1290597233.2072.454.camel@laptop>
	 <20101124123023.GA10413@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 13:46:51 +0100
Message-ID: <1290602811.2072.462.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 20:30 +0800, Wu Fengguang wrote:
> 
> For the 1-dd case, it looks better to lower the break threshold to
> 125ms. After all, it's not easy for the dirty pages to drop by 250ms
> worth of data when you only slept 200ms (note: the max pause time has
> been doubled mainly for servers).
> 
> -               if (nr_dirty < dirty_thresh &&
> -                   bdi_prev_dirty - bdi_dirty > (long)bdi->write_bandwidth / 4)
> +               if (nr_dirty <= dirty_thresh &&
> +                   bdi_prev_dirty - bdi_dirty > (long)bdi->write_bandwidth / 8)
>                         break;

Hrm, but 125ms worth in 200ms is rather easy, you'd want to keep that
limit above what the pause should give you, right?

