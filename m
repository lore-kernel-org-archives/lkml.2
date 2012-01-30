Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2A3XbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:31:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63934 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2A3XbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:31:00 -0500
Date: Mon, 30 Jan 2012 15:30:55 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] PM/Freezer: Make thaw_processes() thaw only
 userspace tasks
Message-ID: <20120130233055.GE27616@google.com>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
 <20120130231437.11129.3708.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130231437.11129.3708.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 04:44:48AM +0530, Srivatsa S. Bhat wrote:
> Currently the situation is:
> 
> freeze_processes() - freezes only userspace tasks
> freeze_kernel_threads() - freezes only kernel threads
> thaw_kernel_threads() - thaws only kernel threads
> thaw_processes() - thaws *everything* (both userspace tasks and kernel threads)

Umm... I don't really get this.  Why is this a problem?  The list is
not even correct.  freeze_kernel_threads() doesn't freeze "only"
kernel threads.  It freezes all threads "including" kernel threads and
that's only natural because you can't freeze kernel threads without
freezing userland threads and of course you can't thaw userland
threads without thawing kernel threads.

The system simply won't work if you do it otherwise and making them
disjoint operations increases the chance of bugs.  These operations
are naturally enclosed within each other and trying to break them
apart isn't a good idea.

What's the problem you're trying to solve here?  I don't really see
code clean up.  Code is different but not necessarily cleaner and FWIW
it seems more unnatural and brittle to me.

Thanks.

-- 
tejun
