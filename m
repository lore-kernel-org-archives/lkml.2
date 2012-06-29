Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2F2BhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:37:00 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56985 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2F2Bg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:36:59 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-5b-4fed06b5b15e
Message-ID: <4FED06C8.1090003@kernel.org>
Date: Fri, 29 Jun 2012 10:37:12 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 0/4] make balloon pages movable by compaction
References: <cover.1340916058.git.aquini@redhat.com>
In-Reply-To: <cover.1340916058.git.aquini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 06/29/2012 06:49 AM, Rafael Aquini wrote:

> This patchset follows the main idea discussed at 2012 LSFMMS section:
> "Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/


Could you summarize the problem, solution instead of link URL in cover-letter?
IIUC, the problem is that it is hard to get contiguous memory in guest-side 
after ballooning happens because guest-side memory could be very fragmented
by ballooned page. It makes THP page allocation of guest-side very poor success ratio.

The solution is that when memory ballooning happens, we allocates ballooned page
as a movable page in guest-side because they can be migrated easily so compaction of
guest-side could put together them into either side so that we can get contiguous memory.
For it, compaction should be aware of ballooned page.

Right?

-- 
Kind regards,
Minchan Kim
