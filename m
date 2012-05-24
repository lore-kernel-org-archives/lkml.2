Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2EXInE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:43:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:36823 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2EXInA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:43:00 -0400
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>, borislav.petkov@amd.com, arnd@arndb.de,
        akinobu.mita@gmail.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, hughd@google.com, jeremy@goop.org,
        len.brown@intel.com, tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4FBDF200.7060608@intel.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
	 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
	 <4FBD18D20200007800085951@nat28.tlf.novell.com>
	 <1337792984.9783.37.camel@laptop>  <4FBDF200.7060608@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 10:42:50 +0200
Message-ID: <1337848970.9783.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 16:32 +0800, Alex Shi wrote:
> So, I use cpumask_t in stack.

cpumask_t is 512 bytes with NR_CPUS=4096, that's generally considered
too big to be on stack.

A number of people spend a lot of time removing cpumask_t from stacks a
while ago, I'm very sure they'll not be happy if you're going to add it
back.

Rusty, what was the plan on removing cpumask_t altogether?

