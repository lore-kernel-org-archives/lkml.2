Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1ITPlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:41:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44406 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab1ITPk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:40:58 -0400
Date: Tue, 20 Sep 2011 20:49:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 0/26]   Uprobes patchset with perf
 probe support
Message-ID: <20110920151903.GA22802@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920133401.GA28550@infradead.org>
 <20110920141204.GC6568@linux.vnet.ibm.com>
 <20110920142843.GA9995@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110920142843.GA9995@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092015-6078-0000-0000-000000FB841C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2011-09-20 10:28:43]:

> On Tue, Sep 20, 2011 at 07:42:04PM +0530, Srikar Dronamraju wrote:
> > I could use any other inode/file/mapping based sleepable lock that is of
> > higher order than mmap_sem. Can you please let me know if we have
> > alternatives.
> 
> Please do not overload unrelated locks for this, but add a specific one.
> 
> There's two options:
> 
>  (a) add it to the inode (conditionally)
>  (b) use global, hashed locks
> 
> I think (b) is good enough as adding/removing probes isn't exactly the
> most critical fast path.
> 

Agree, I will replace the i_mutex with a uprobes specific hash locks.
I will make this change as part of next patchset.

-- 
Thanks and Regards
Srikar

