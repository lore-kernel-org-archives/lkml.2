Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1BUTJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:09:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:8560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1BUTIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:08:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,201,1297065600"; 
   d="scan'208";a="711415552"
From: Andi Kleen <andi@firstfloor.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Improve drain pages performance on large systems
References: <20110215223840.GA27420@sgi.com>
Date: Tue, 15 Feb 2011 16:17:44 -0800
In-Reply-To: <20110215223840.GA27420@sgi.com> (Jack Steiner's message of "Tue,
	15 Feb 2011 16:38:40 -0600")
Message-ID: <m262skx26v.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner <steiner@sgi.com> writes:

> Heavy swapping within a cpuset causes frequent calls to drain_all_pages().

I suspect drain_all_pages should be really made more zone aware in the
first place and only drain what is actually needed (e.g.
work off a zonelist). I was fighting with this for hwpoison too.

That said your patch looks reasonable.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
