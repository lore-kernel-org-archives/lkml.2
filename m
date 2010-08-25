Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab0HYHAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:00:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53460 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0HYHA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:00:28 -0400
Date: Wed, 25 Aug 2010 12:25:41 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Using perf probe with arguments throws a fatal error.
Message-ID: <20100825065541.GE14431@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100824045758.GA14431@linux.vnet.ibm.com>
 <4C738411.8080602@hitachi.com>
 <20100824085401.GB14431@linux.vnet.ibm.com>
 <4C738F09.3080108@hitachi.com>
 <20100824095658.GC14431@linux.vnet.ibm.com>
 <4C74AE7B.1010705@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C74AE7B.1010705@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The differences I see when a name is given we refer the name, while in
> > the previous case we refer the register %ip.
> 
> Ah, I remembered that, yeah, perf doesn't support those raw regsiters,
> dereferences, etc.
> Hmm, this should be solved, but not so simple as just removing "%",
> because there are also special variables ($retval, $stack) and
> dereferences(+8(+10(%sp)), etc).
> 
> I think the simplest solution is just setting "argX" name for each
> argument (if user omitted its name) in kprobe-tracer (because
> trace-cmd will face same problem).
> e.g.
>  # echo "p do_fork %ip" > tracing/kprobe_events
> will be translated as below
>  # echo "p do_fork arg1=%ip" > tracing/kprobe_events
> 

Okay, I will follow the same and fix the argX name in uprobe-tracer.

--
Thanks and Regards
Srikar
