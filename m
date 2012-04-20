Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2DTK6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:58:11 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:41227 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705Ab2DTK6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:58:09 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 06:58:09 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEs/kU95LdRK/2dsb2JhbABDsTyBCIIJAQEFJxMcIxALGBwSFBgNJIghuwuQBGMElXiJWYZlgnk
Date: Fri, 20 Apr 2012 20:52:55 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH v2 05/10] mm: kill vma flag VM_CAN_NONLINEAR
Message-ID: <20120420105255.GC25458@amd.local0.net>
References: <20120407185546.9726.62260.stgit@zurg>
 <20120407190115.9726.85024.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120407190115.9726.85024.stgit@zurg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2012 at 11:01:15PM +0400, Konstantin Khlebnikov wrote:
> This patch moves actual ptes filling for non-linear file mappings
> into special vma operation: ->remap_pages().
> 
> Now fs must implement this method to get non-linear mappings support.
> If fs uses filemap_fault() then it can use generic_file_remap_pages() for this.
> 

This should enable drivers that prepopulate mappings at mmap() time to
support nonlinear mappings! (I don't know if anyone uses these things
anymore, or ever had except for Oracle, but that's quite besides the
point).

Please update documentation?

Thanks,
Nick

