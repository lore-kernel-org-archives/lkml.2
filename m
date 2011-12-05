Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1LESaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:30:15 -0500
Received: from lo.gmane.org ([80.91.229.12]:52999 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab1LESaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:30:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthew Maurer <maurer@ugcs.caltech.edu>
Subject: Re: [PATCH v5 4/9] x86-64: Remove kernel.vsyscall64 sysctl
Date: Mon, 5 Dec 2011 18:27:09 +0000 (UTC)
Message-ID: <loom.20111205T192515-288@post.gmane.org>
References: <cover.1307292171.git.luto@mit.edu> <973ae803fe76f712da4b2740e66dccf452d3b1e4.1307292171.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 128.237.247.56 (Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto <at> MIT.EDU> writes:

> 
> It's unnecessary overhead in code that's supposed to be highly
> optimized.  Removing it allows us to remove one of the two syscall
> instructions in the vsyscall page.
> 
> The only sensible use for it is for UML users, and it doesn't fully
> address inconsistent vsyscall results on UML.  The real fix for UML
> is to stop using vsyscalls entirely.

UML is not the only use case for this. Anybody who wants to be able to
trace _all_ system calls (for debugging, ptrace-based sandboxing, or a
number of other purposes) needs this.

We either need this back, or need another way to make it possible to
trace these system calls.

Apologies for the late reply, I didn't notice this change until it got
into my distribution's kernel.

--Matthew Maurer

