Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2EHEuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:50:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2EHEuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:50:52 -0400
Date: Tue, 8 May 2012 05:50:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <npiggin@kernel.dk>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] lglock: remove online variants of lock
Message-ID: <20120508045044.GJ22082@ZenIV.linux.org.uk>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228112422.GC11324@alboin.amr.corp.intel.com>
 <87ipijzfwn.fsf@rustcorp.com.au>
 <20120420112149.GH25458@amd.local0.net>
 <87sjfcfynb.fsf@rustcorp.com.au>
 <20120507054616.GG22082@ZenIV.linux.org.uk>
 <87txzrcoge.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txzrcoge.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 01:29:45PM +0930, Rusty Russell wrote:
> Optimizing the slow paths adds a lot of complexity.  If you need to
> grab every lock often, you have other problems.

Applied, but I'm not too happy about the situation with vfsmount_lock ;-/
On kernels built for a lot of possible CPUs the loss of ..._online()
versions will get painful.  OTOH, we can always put the map + single
spinlock + single notifier into lglock.c and reproduce the old logics.
I'll do a patch along those lines and put it on a separate branch;
then we'll be able to test and compare.

Contention from cpu map spinlock becoming shared between different
lglocks (all two of them) is not an issue - we never use the
files_lock one anyway (there we can't use _online variants).
