Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2CGMtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:49:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52397 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757468Ab2CGMtc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:49:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120305154753.GA14604@elte.hu>
References: <20120224094048.GA7952@quad>
	<20120305154753.GA14604@elte.hu>
Date: Wed, 7 Mar 2012 13:49:30 +0100
Message-ID: <CABPqkBQ6rYstBwLYsGrRZEj4faPR2i0k7b4QasrhRD-9JH9DTA@mail.gmail.com>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 4:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Another usability bug of the new branch sampling feature is that
> typing the obvious:
>
>  $ perf record -b ./myprog
>
> does not do the obvious thing and default to 'any' but throws a
> *very* unhelpful generic perf error:
>
Ok, so looked at this. Given the option parsing code, looks like
we would have to split the option in two: -b and something else
to disambiguate cmdline such as:

$ perf record -b foo
$ perf record -b any_call foo
any_call: no such file or directory

The code cannot disambiguate between any_call being a branch filter
vs. the command
to run, given that -b has now an optional argument.

What we can do is split: -b and --branch-filter for instance. The former
takes no argument and sets up branch-stack to ANY. The other one requires
a parameter.

I am almost done with  TUI navigation of branch samples.

>  usage: perf record [<options>] [<command>]
>    or: perf record [<options>] -- <command> [<options>]
>
>  ...
>
> Really, we should do better than this. Only people who *want* to
> specify finer LBR filters should be forced to specify them.
>
> Thanks,
>
>        Ingo
