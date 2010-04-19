Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0DSEbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 00:31:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:53434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0DSEbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 00:31:21 -0400
Date: Sun, 18 Apr 2010 21:32:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100418213238.2e62eac7@infradead.org>
In-Reply-To: <20100419010805.GD2520@dastard>
References: <20100414155233.D153.A69D9226@jp.fujitsu.com>
	<20100414072830.GK2493@dastard>
	<20100414085132.GJ25756@csn.ul.ie>
	<20100415013436.GO2493@dastard>
	<20100415102837.GB10966@csn.ul.ie>
	<20100416041412.GY2493@dastard>
	<20100416151403.GM19264@csn.ul.ie>
	<20100417203239.dda79e88.akpm@linux-foundation.org>
	<20100419003556.GC2520@dastard>
	<20100418174944.7b9716ad@infradead.org>
	<20100419010805.GD2520@dastard>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 11:08:05 +1000
Dave Chinner <david@fromorbit.com> wrote:

> > Maybe we need to do the background dirty writes a bit more
> > aggressive... or play with heuristics where we get an adaptive
> > timeout (say, if the file got closed by the last opener, then do a
> > shorter timeout)
> 
> Realistically, I'm concerned about preventing the worst case
> behaviour from occurring - making the background writes more
> agressive without preventing writeback in LRU order simply means it
> will be harder to test the VM corner case that triggers these
> writeout patterns...


while I appreciate that the worst case should not be uber horrific...
I care a LOT about getting the normal case right... and am willing to
sacrifice the worst case for that.. (obviously not to infinity, it
needs to be bounded)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
