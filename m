Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2A3WJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:09:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52635 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2A3WJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:09:26 -0500
Date: Mon, 30 Jan 2012 14:09:19 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] PM/Freezer: Make thaw_processes() thaw only
 userspace tasks
Message-ID: <20120130220919.GC27616@google.com>
References: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com>
 <20120130220419.9442.39596.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130220419.9442.39596.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 03:34:57AM +0530, Srivatsa S. Bhat wrote:
> Currently the situation is:
> 
> freeze_processes() - freezes only userspace tasks
> freeze_kernel_threads() - freezes only kernel threads
> thaw_kernel_threads() - thaws only kernel threads
> thaw_processes() - thaws *everything* (both userspace tasks and kernel threads)
> 
> The point that thaw_processes() thaws everything is rather unintuitive
> and can lead to bugs. So, modify thaw_processes() so that it thaws only
> userspace processes. This way we can also have more control over what
> exactly gets thawed in different situations.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Maybe I'm misreading it but doesn't this introduce window where kernel
tasks aren't thawed between this patch and the following ones?  It
looks like this one should come later.

Thanks.

-- 
tejun
