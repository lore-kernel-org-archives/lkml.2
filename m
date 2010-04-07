Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0DGAH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:07:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab0DGAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:33 -0400
Date: Tue, 6 Apr 2010 17:06:13 -0700
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
Subject: Re: [PATCH 12/14] Add a tunable that decides when memory should be
 compacted and when it should be reclaimed
Message-Id: <20100406170613.9b80c7ea.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-13-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-13-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:46 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> The kernel applies some heuristics when deciding if memory should be
> compacted or reclaimed to satisfy a high-order allocation. One of these
> is based on the fragmentation. If the index is below 500, memory will
> not be compacted. This choice is arbitrary and not based on data. To
> help optimise the system and set a sensible default for this value, this
> patch adds a sysctl extfrag_threshold. The kernel will only compact
> memory if the fragmentation index is above the extfrag_threshold.

Was this the most robust, reliable, no-2am-phone-calls thing we could
have done?

What about, say, just doing a bit of both until something worked?  For
extra smarts we could remember what worked best last time, and make
ourselves more likely to try that next time.

Or whatever, but extfrag_threshold must die!  And replacing it with a
hardwired constant doesn't count ;)

