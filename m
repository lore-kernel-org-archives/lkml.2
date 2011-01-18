Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1ARGem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:34:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52992
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab1ARGek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:34:40 -0500
Date: Mon, 17 Jan 2011 22:35:13 -0800 (PST)
Message-Id: <20110117.223513.183031917.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, Jesper.Nilsson@axis.com,
        jeffm@suse.com, mathieu.desnoyers@efficios.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295273741.16479.19.camel@gandalf.stny.rr.com>
References: <20110116.220755.179947617.davem@davemloft.net>
	<1295259761.32152.20.camel@duncow>
	<1295273741.16479.19.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 17 Jan 2011 09:15:41 -0500

> Again, this is to help the linker keep arrays in tacked. Tracepoints are
> allocated into the tracepoint section, and then read like an array. If
> the linker adds holes as it links sections into one big one, then the
> reading of the array breaks.
> 
> We either need to compact it (with the align(4)) which is undesirable,
> or add our own holes like the above does.

Just take away all of the align directives, it should just work.

If it doesn't, then we should investigate to find out the real reason
why.

The linker has no reason to add holes, and in fact if we are to believe
the commit message for 86c38a31aa7f2dd6e74a262710bf8ebf7455acc5
("tracing: Fix ftrace_event_call alignment for use with gcc 4.5"), with
gcc-4.x where x < 5, it did work even though some ftrace_event_call
declarations lacked the align directive.

If this align thing is so critical, why don't we need it for the
exception table entries which live in the "__ex_table" section in the
kernel?  It's the same _exact_ kind of thing, and the asm sequence we
use to populate it is identical to what GCC emits for the tracing
object declarations in question.
