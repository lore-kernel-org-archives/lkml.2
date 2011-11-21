Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1KUM5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:57:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1KUM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:57:21 -0500
Date: Mon, 21 Nov 2011 12:57:17 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] Revert "mm: compaction: make isolate_lru_page()
 filter-aware"
Message-ID: <20111121125717.GE19415@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
 <1321732460-14155-7-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1321732460-14155-7-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 08:54:18PM +0100, Andrea Arcangeli wrote:
> This reverts commit
> 39deaf8585152f1a35c1676d3d7dc6ae0fb65967.
> 
> PageDirty is non blocking for compaction (unlike for
> mm/vmscan.c:may_writepage) so async compaction should include it.
> 

It blocks if fallback_migrate_page() is used which happens if the
underlying filesystem does not support ->migratepage.

-- 
Mel Gorman
SUSE Labs
