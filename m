Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2BWSo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:44:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:44291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2BWSo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:44:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120626184"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: cl@linux.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel>
Date: Thu, 23 Feb 2012 10:45:00 -0800
In-Reply-To: <20120223180740.C4EC4156@kernel> (Dave Hansen's message of "Thu,
	23 Feb 2012 10:07:40 -0800")
Message-ID: <m2zkc9pexf.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> sys_move_pages() and sys_migrate_pages() are a pretty nice copy
> and paste job of each other.  They both take a pid, find the task
> struct, and then grab a ref on the mm.  They both also do an
> rcu_read_unlock() after they've taken the mm and then proceed to
> access 'task'.  I think this is a bug in both cases.

Can we share code?


>
> This patch takes the pid-to-task code along with the credential
> and security checks in sys_move_pages() and sys_migrate_pages()
> and consolidates them.  It now takes a task reference in
> the new function and requires the caller to drop it.  I
> believe this resolves the race.

Looks good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

BTW looks like we really need a better stress test for these
syscalls.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
