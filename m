Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1KJXMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:12:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab1KJXMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:12:13 -0500
Date: Thu, 10 Nov 2011 15:12:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-Id: <20111110151211.523fa185.akpm@linux-foundation.org>
In-Reply-To: <20111110161331.GG3083@suse.de>
References: <20111110100616.GD3083@suse.de>
	<20111110142202.GE3083@suse.de>
	<CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
	<20111110161331.GG3083@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011 16:13:31 +0000
Mel Gorman <mgorman@suse.de> wrote:

> This patch once again prevents sync migration for transparent
> hugepage allocations as it is preferable to fail a THP allocation
> than stall.

Who said?  ;) Presumably some people would prefer to get lots of
huge pages for their 1000-hour compute job, and waiting a bit to get
those pages is acceptable.

Do we have the accounting in place for us to be able to determine how
many huge page allocation attempts failed due to this change?

