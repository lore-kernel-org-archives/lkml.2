Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab1F2UOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:14:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:28730 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab1F2UOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,445,1304319600"; 
   d="scan'208";a="19829694"
From: Andi Kleen <andi@firstfloor.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
References: <1309376033-32005-1-git-send-email-dima@android.com>
Date: Wed, 29 Jun 2011 13:13:22 -0700
In-Reply-To: <1309376033-32005-1-git-send-email-dima@android.com> (Dima
	Zavin's message of "Wed, 29 Jun 2011 12:33:53 -0700")
Message-ID: <m2tyb81jml.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dima Zavin <dima@android.com> writes:

> Currently, plist debugging "enforces" that the plist is locked
> with either a raw_spinlock or a spinlock. The plist data structure
> is useful in other places, where spinlocks are unnecessary.
>
> Extend the plist initializers and debug checks to allow the plist
> to be protected by a mutex

Seems really ugly and clearly not a godo path. 

It's a bit like adding a 11th argument to a function which already has 
10.

Perhaps better move out the locking completely to wrappers and remove
the knowledge from the core plist code.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
