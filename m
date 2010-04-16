Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0DPX4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 19:56:35 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:59740 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab0DPX4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 19:56:34 -0400
Date: Sat, 17 Apr 2010 01:56:18 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100416235618.GL20640@cmpxchg.org>
References: <20100414085132.GJ25756@csn.ul.ie> <20100415023704.GC20640@cmpxchg.org> <20100415114043.D162.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415114043.D162.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 11:43:48AM +0900, KOSAKI Motohiro wrote:
> > I already have some patches to remove trivial parts of struct scan_control,
> > namely may_unmap, may_swap, all_unreclaimable and isolate_pages.  The rest
> > needs a deeper look.
> 
> Seems interesting. but scan_control diet is not so effective. How much
> bytes can we diet by it?

Not much, it cuts 16 bytes on x86 32 bit.  The bigger gain is the code
clarification it comes with.  There is too much state to keep track of
in reclaim.
