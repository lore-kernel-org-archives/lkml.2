Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892Ab2BNO7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:59:54 -0500
Received: from gw.danplanet.com ([50.43.125.66]:35302 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751007Ab2BNO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:59:53 -0500
From: Dan Smith <danms@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
	<87zkcm23az.fsf@caffeine.danplanet.com>
	<alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
Date: Tue, 14 Feb 2012 06:59:51 -0800
In-Reply-To: <alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
	(David Rientjes's message of "Mon, 13 Feb 2012 13:55:31 -0800 (PST)")
Message-ID: <87pqdh1mvs.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DR> That's not a precedent, there's a big difference between the
DR> performance of gup_fast(), where we can't spare an additional
DR> compare and branch, and walk_page_range().  VM_BUG_ON() is typically
DR> used in situations where a debug kernel has been built, including
DR> CONFIG_DEBUG_VM, and the check helps to isolate a problem that would
DR> be otherwise difficult to find.

Okay, fair enough. I was trying to stay in line with the other
conventions, knowing that the check would only be done with
CONFIG_DEBUG_VM enabled.

I'd rather just make it always do the check in walk_page_range(). Does
that sound reasonable?

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
