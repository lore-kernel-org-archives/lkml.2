Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441Ab2FDMYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:24:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49244 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2FDMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:24:18 -0400
X-AuditID: b753bd60-918caba000001453-0f-4fcca8effbdf
X-AuditID: b753bd60-918caba000001453-0f-4fcca8effbdf
Message-ID: <4FCCA8E7.5070407@hitachi.com>
Date: Mon, 04 Jun 2012 21:24:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe optimization
References: <20120529124833.9191.23007.stgit@localhost.localdomain>     <1338331514.13348.298.camel@gandalf.stny.rr.com>     <4FC5C55E.9000909@hitachi.com>    <1338377978.13348.308.camel@gandalf.stny.rr.com>    <4FC787D8.4010904@hitachi.com>   <1338477346.13348.351.camel@gandalf.stny.rr.com>   <4FC8C557.9010407@hitachi.com>  <1338560427.13348.466.camel@gandalf.stny.rr.com>  <4FCC9FC8.7060302@hitachi.com> <1338811649.13348.486.camel@gandalf.stny.rr.com>
In-Reply-To: <1338811649.13348.486.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/04 21:07), Steven Rostedt wrote:
> On Mon, 2012-06-04 at 20:45 +0900, Masami Hiramatsu wrote:
>> I think if I just register kprobe's ftrace_ops without start
>> tracing, I think we can just do tracing without "notrace".
> 
> You should be able to register the filter first, and then register
> function tracer. If you register without setting the filter, you will
> start tracing all functions.
> 
> I think that may be the problem you are seeing. You want to register the
> filter first and then the ftrace_ops.

Ah, that's all what I need to know! :)
OK, I'll do that for avoiding recursion problem.

Thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
