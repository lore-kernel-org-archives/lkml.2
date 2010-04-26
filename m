Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0DZSAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab0DZSAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:00:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm v6] tracepoint: Add signal coredump tracepoint
In-Reply-To: Masami Hiramatsu's message of  Friday, 23 April 2010 20:50:11 -0400 <4BD24043.3090604@redhat.com>
References: <20100412164830.514.85103.stgit@localhost6.localdomain6>
	<20100421001856.83743D10E@magilla.sf.frob.com>
	<4BCF0C39.1080907@redhat.com>
	<20100424001423.2AA831909E@magilla.sf.frob.com>
	<4BD24043.3090604@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100426175924.B8B501AD11@magilla.sf.frob.com>
Date: Mon, 26 Apr 2010 10:59:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think retval decoding will help us to find which condition caused
> failing the coredump, by reading the source code.
> So, I'd like to leave it.

Having a proper -ERR* code for the cases that have one in your patch is
certainly good.  What I meant was using the 0/1 values to distinguish
success vs failure from the binfmt dumper.  If there were separate
tracepoints for success vs failure, then the failure one should certainly
get an error code, which would be 0 when the error (or refusal to dump) was
due to some decision made by the binfmt code rather than a write error.

> Hmm, indeed. it seems that those tracepoints are useful for finding
> unexpected delays from coredump...
> OK, I'll try to add those tracepoints. Would you have any recommended data
> which those tracepoints should record?

Whatever is handy, I suppose.  i.e. of the things you pass into the
tracepoint now, give each tracepoint the subset that makes sense for its
case.  For the tracepoint after synchronization and before dumping, I think
it should be more or less right after format_corename() and it can pass the
ispipe, corename, cprm.limit and binfmt->min_coredump values that affect
the tests immediately thereafter (as well as the full cprm and binfmt
pointers).


Thanks,
Roland
