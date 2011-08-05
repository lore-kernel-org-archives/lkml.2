Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1HEWKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:10:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:38941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1HEWKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:10:42 -0400
Subject: Re: [PATCH] jump label: Reduce the cycle count by changing the link
 order
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, pjt@google.com, mingo@elte.hu, rth@redhat.com,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 00:10:09 +0200
In-Reply-To: <20110805204040.GG2522@redhat.com>
References: <20110805204040.GG2522@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312582209.28695.51.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 16:40 -0400, Jason Baron wrote:
> In the course of testing jump labels for use with the CFS bandwidth controller,
> Paul Turner, discovered that using jump labels reduced the branch count and the
> instruction count, but did not reduce the cycle count or wall time.
> 
> I noticed that having the jump_label.o included in the kernel but not used in
> any way still caused this increase in cycle count and wall time. Thus, I moved
> jump_label.o in the kernel/Makefile, thus changing the link order, and
> presumably moving it out of hot icache areas. This brought down the cycle
> count/time as expected.
> 
> In addition to Paul's testing,  I've tested the patch using a single
> 'static_branch()' in the getppid() path, and basically running tight loops of
> calls to getppid(). Here are my results for the branch disabled case:

Those numbers don't seem to be pre/post patch, but merely
CONFIG_JUMP_LABEL=y/n so they don't tell us what the patch does.

Anyway, should we put a comment in the Makefile telling us we should
keep jump_label.o last?

Also, pjt mentioned on IRC that mucking about with link order is
something google is not unfamiliar with.. could we use some sort of
runtime feedback to generate linker layout maps or so? That seems like a
more scalable version than randomly mucking about with Makefiles :-)
