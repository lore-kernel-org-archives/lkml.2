Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2BJUXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:23:32 -0500
Received: from gw.danplanet.com ([50.43.125.66]:42148 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932337Ab2BJUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:23:31 -0500
X-Greylist: delayed 1558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Feb 2012 15:23:31 EST
From: Dan Smith <danms@us.ibm.com>
To: "Michal Nazarewicz" <mina86@mina86.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<op.v9hahmw23l0zgt@mpn-glaptop>
Date: Fri, 10 Feb 2012 11:57:31 -0800
In-Reply-To: <op.v9hahmw23l0zgt@mpn-glaptop> (Michal Nazarewicz's message of
	"Fri, 10 Feb 2012 20:45:12 +0100")
Message-ID: <874nuy31hw.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MN> Commit message says about walk_pte_range() but commit changes
MN> walk_page_range().

Yep, the issue occurs in walk_pte_range(). The goal was to ensure that
the external interface to it (which is walk_page_range()) does the check
and avoids doing the walk entirely. I think the expectation is that
walk_page_range() is used on aligned addresses. If we put the check in
walk_pte_range() then only walks with a pte_entry handler would fail on
unaligned addresses, which is potentially confusing.

MN> So why not change the condition to addr < end?

That would work, of course, but seems sloppier and less precise. The
existing code was clearly written expecting to walk aligned addresses.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
