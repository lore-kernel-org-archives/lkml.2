Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab0CWEmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:42:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab0CWEms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:42:48 -0400
Date: Mon, 22 Mar 2010 21:38:36 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/10] Uprobes patches.
Message-Id: <20100322213836.56a82d34.akpm@linux-foundation.org>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010 19:54:55 +0530 Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> This patchset implements Uprobes which enables you to dynamically break
> into any routine in a user space application and collect information
> non-disruptively.

What's missing here is a description of why all this is useful. 
Presumably much of the functionality which this feature offers can be
done wholly in userspace.  So I think it would be useful if you were to
carefully explain the thinking here - what the value is, how people
will use it, why it needs to be done in-kernel, etc.  Right now if I
was asked "why did you merge that", I'd say "gee, I dunno".  I say that
a lot.  Knowing all of this would perhaps help me to understand your
thinking regarding ftrace integration.

The code itself is positioned as non-x86-specific, but the
implementation is x86-only.  It would be nice to get some confirmation
that other architectures can successfully use the core code.  But that
will be hard to arrange, so probably crossing our fingers is the best
approach here.

The code scares me a bit from the "how can malicious people exploit it"
point of view.  Breaking into other users programs/memory, causing the
kernel to scribble on itself, causing unbound memory consumption, etc. 
No specific issues that I can point at, just vague fear.

Do we know that exiting userspace will never ever already be using int3?

What happens if I run this code in 2016 on a CPU which has new opcodes
which this code didn't know about?

When uprobes was being pushed five-odd years ago, it did all sorts of
hair-raising things to avoid COWing shared pages.  Lots of reasons were
given why it *had* to avoid COW.  But now it COWs.  What were those
reasons why COW was unacceptable, and what changed?

