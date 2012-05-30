Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2E3HAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:00:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56895 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2E3G76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:59:58 -0400
X-AuditID: b753bd60-a2688ba000000655-60-4fc5c56aa3d7
X-AuditID: b753bd60-a2688ba000000655-60-4fc5c56aa3d7
Message-ID: <4FC5C55E.9000909@hitachi.com>
Date: Wed, 30 May 2012 15:59:42 +0900
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
References: <20120529124833.9191.23007.stgit@localhost.localdomain> <1338331514.13348.298.camel@gandalf.stny.rr.com>
In-Reply-To: <1338331514.13348.298.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/30 7:45), Steven Rostedt wrote:
> On Tue, 2012-05-29 at 21:48 +0900, Masami Hiramatsu wrote:
> 
>> Also, this makes all __kprobes functions "notrace", because
>> some of those functions are considered as to be called from
>> kprobes handler which is called from function tracer.
>> I think that is another discussion point. Perhaps, we need
>> to introduce another tag which means "don't put kprobe on
>> this function" instead of __kprobes and apply that.
> 
> Actually, instead, we can force kprobes to have all "__kprobes"
> functions added to its 'notrace' ftrace_ops. This will just keep kprobes
> from function tracing these, as I find myself tracing functions marked
> by kprobes quite a bit.

Hmm, I'm not so sure how the notrace and filter works.
What happens if I set a foo function-entry on filter
and keep notrace empty?
 - only foo's nop is replaced with call?
 - or all functions including foo is traced?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
