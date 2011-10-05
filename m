Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861Ab1JEPQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:16:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:60253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934812Ab1JEPQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:16:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60179102"
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] IO-less dirty throttling v12
References: <20111003134228.090592370@intel.com>
	<20111004195206.GG28306@redhat.com>
Date: Wed, 05 Oct 2011 08:16:41 -0700
In-Reply-To: <20111004195206.GG28306@redhat.com> (Vivek Goyal's message of
	"Tue, 4 Oct 2011 15:52:06 -0400")
Message-ID: <m2ipo34gfa.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:
>
> Will it make sense to break down this work in two patch series. First
> push IO less balance dirty pages and then all the complicated pieces
> of ratelimits.

I would be wary against too much refactoring of well tested patchkits.
I've seen too many cases where this can add nasty and subtle bugs,
given that our unit test coverage is usually relatively poor.

For example the infamous "absolute path names became twice as slow" 
bug was very likely introduced in such a refactoring of a large VFS
patchkit.

While it's generally good to make things easier for reviewers too much
of a good thing can be quite bad.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
