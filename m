Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1CCTqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:46:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37533 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab1CCTqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:46:42 -0500
Date: Thu, 3 Mar 2011 19:46:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable writing to /proc/PID/mem.
Message-ID: <20110303194626.GN22723@ZenIV.linux.org.uk>
References: <1299118074-13342-1-git-send-email-wilsons@start.ca>
 <20110303111240.B942.A69D9226@jp.fujitsu.com>
 <20110303193802.GA4994@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303193802.GA4994@fibrous.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 02:38:02PM -0500, Stephen Wilson wrote:
> > I haven't found any problem in this patch. But, I really believe we need
> > to understand why it was marked "security hazard". Al, I guess you know it,
> > right? So, can you please talk us your mention?
> 
> I did a bit more digging trying to find why mem_write was marked a security
> hazard.
> 
> It goes back to 2.4.0-test10pre4.  Unfortunately, the changelog entry is
> not at all informative either:
> 
> 	- disable writing to /proc/xxx/mem. Sure, it works now, but it's
> 	  still a security risk.

Think what happens if the target execs suid-root binary in the middle of your
call.  After you've done your check.  E.g. during copy_from_user().

On the read side we actually recheck permissions after having copied into
buffer and if the check fails we don't copy that buffer into userland.
Not feasible on the write side...
