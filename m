Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2HHAFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:05:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab2HHAFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:05:21 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=_9X4mZNrW6gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=SyI_GHdlAAAA:8 a=kz-6L6J5Rigc07B7VOYA:9 a=PUjeQqilurYA:10 a=UQxMgyrMzRwA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344384318.6935.12.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 1/4] ftrace: Make recordmcount.c handle __fentry__
From: Steven Rostedt <rostedt@goodmis.org>
To: John Reiser <jreiser@bitwagon.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Tue, 07 Aug 2012 20:05:18 -0400
In-Reply-To: <5021AB86.30900@bitwagon.com>
References: <20120807193845.146666357@goodmis.org>
	 <20120807194058.990674363@goodmis.org> <5021AB86.30900@bitwagon.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 16:57 -0700, John Reiser wrote:

> If the user changes compilers (or changes CFLAGS by insert/remove "-mfentry")
> without doing a "make clean", then recordmcount will omit some calls.

The make dependencies of such a change should (hopefully) cause a full
recompile of the code. Yeah, I expect that we only have "mcount" or
"fentry" as something that can be called. If we had both mcount and
fentry, it would fail to link anyway, as we only define mcount or fentry
in the assembly, never both.

> 
> Those restrictions are easy to guess, and recovery is easy.  Therefore,
> Ack'ed by: John Reiser <jreiser@bitwagon.com>
> 

Thanks!

-- Steve


