Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1HaLUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab1HaLUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:20:32 -0400
Date: Wed, 31 Aug 2011 13:19:54 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3] compaction: compact unevictable page
Message-ID: <20110831111954.GB17512@redhat.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 01:37:42AM +0900, Minchan Kim wrote:
> Now compaction doesn't handle mlocked page as it uses __isolate_lru_page
> which doesn't consider unevicatable page. It has been used by just lumpy so
> it was pointless that it isolates unevictable page. But the situation is
> changed. Compaction could handle unevictable page and it can help getting
> big contiguos pages in fragment memory by many pinned page with mlock.

This may result in applications unexpectedly faulting and waiting on
mlocked pages under migration.  I wonder how realtime people feel
about that?
