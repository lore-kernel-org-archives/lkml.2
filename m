Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab2E2WpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:45:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2E2WpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:45:17 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wwwCnHkgN0EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=2focIdWqE8m9eROobXYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338331514.13348.298.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe
 optimization
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 29 May 2012 18:45:14 -0400
In-Reply-To: <20120529124833.9191.23007.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 21:48 +0900, Masami Hiramatsu wrote:

> Also, this makes all __kprobes functions "notrace", because
> some of those functions are considered as to be called from
> kprobes handler which is called from function tracer.
> I think that is another discussion point. Perhaps, we need
> to introduce another tag which means "don't put kprobe on
> this function" instead of __kprobes and apply that.

Actually, instead, we can force kprobes to have all "__kprobes"
functions added to its 'notrace' ftrace_ops. This will just keep kprobes
from function tracing these, as I find myself tracing functions marked
by kprobes quite a bit.

-- Steve


