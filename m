Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab0DGAGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:06:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209Ab0DGAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:23 -0400
Date: Tue, 6 Apr 2010 17:05:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 06/14] Export fragmentation index via
 /proc/extfrag_index
Message-Id: <20100406170542.fe9b9f33.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-7-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-7-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:40 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> Fragmentation index is a value that makes sense when an allocation of a
> given size would fail. The index indicates whether an allocation failure is
> due to a lack of memory (values towards 0) or due to external fragmentation
> (value towards 1).  For the most part, the huge page size will be the size
> of interest but not necessarily so it is exported on a per-order and per-zone
> basis via /proc/extfrag_index

(/proc/sys/vm?)

Like unusable_index, this seems awfully specialised.  Perhaps we could
hide it under CONFIG_MEL, or even put it in debugfs with the intention
of removing it in 6 or 12 months time.  Either way, it's hard to
justify permanently adding this stuff to every kernel in the world?


I have a suspicion that all the info in unusable_index and
extfrag_index could be computed from userspace using /proc/kpageflags
(and perhaps a bit of dmesg-diddling to find the zones).  If that can't
be done today, I bet it'd be pretty easy to arrange for it.


