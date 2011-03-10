Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1CJQBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:01:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:3268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1CJQAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:00:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,296,1297065600"; 
   d="scan'208";a="400673947"
Date: Thu, 10 Mar 2011 08:00:32 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] make *_gate_vma accept mm_struct instead of
 task_struct
Message-ID: <20110310160032.GA20504@alboin.amr.corp.intel.com>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299630721-4337-1-git-send-email-wilsons@start.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 07:31:56PM -0500, Stephen Wilson wrote:
> 
> Morally, the question of whether an address lies in a gate vma should be asked
> with respect to an mm, not a particular task.
> 
> Practically, dropping the dependency on task_struct will help make current and
> future operations on mm's more flexible and convenient.  In particular, it
> allows some code paths to avoid the need to hold task_lock.
> 
> The only architecture this change impacts in any significant way is x86_64.
> The principle change on that architecture is to mirror TIF_IA32 via
> a new flag in mm_context_t. 

The problem is -- you're adding a likely cache miss on mm_struct for
every 32bit compat syscall now, even if they don't need mm_struct
currently (and a lot of them do not) Unless there's a very good
justification to make up for this performance issue elsewhere
(including numbers) this seems like a bad idea.

> This is the first of a two part series that implements safe writes to
> /proc/pid/mem.  I will be posting the second series to lkml shortly.  These

Making every syscall slower for /proc/pid/mem doesn't seem like a good
tradeoff to me. Please solve this in some other way.

-Andi
