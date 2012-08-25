Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab2HYBAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 21:00:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2HYBAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:00:42 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=OdopumH5WhQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=rar5W1_n13MA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=z1_DotE7mYqKS33IgrsA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345856440.12440.21.camel@gandalf.local.home>
Subject: Re: BUG: Kprobe smoke test: 2 out of 6 tests failed
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Date: Fri, 24 Aug 2012 21:00:40 -0400
In-Reply-To: <1345815698.12440.12.camel@gandalf.local.home>
References: <20120824071512.GA965@localhost>
	 <1345815698.12440.12.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 09:41 -0400, Steven Rostedt wrote:

> On Fri, 2012-08-24 at 15:15 +0800, Fengguang Wu wrote:
> > Hi Steven,
> > 
> > The following test fails are mostly due to this commit, or one of the
> > last 4 commits in
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git tip/perf/core
> > head:   d57c5d51a30152f3175d2344cb6395f08bf8ee0c
> > commit: d57c5d51a30152f3175d2344cb6395f08bf8ee0c [100/100] ftrace/x86: Add support for -mfentry to x86_64
> > 
> > [    9.084881] Kprobe smoke test failed: register_jprobe returned -22
> > [    9.086786] Kprobe smoke test failed: register_jprobes returned -22

Masami,

Seems that when we use fentry, we break jprobes. I thought the patches
that we added would just move the call to the next op, not fail totally?

Are jprobes deprecated?

-- Steve

> > [    9.121281] BUG: Kprobe smoke test: 2 out of 6 tests failed
> > [    9.171132] Testing tracer function: PASSED
> > [    9.408938] Testing dynamic ftrace: PASSED
> > 
> > Thanks,
> > Fengguang
> 


