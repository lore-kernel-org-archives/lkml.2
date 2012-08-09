Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2HIC7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 22:59:05 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35096 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2HIC7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 22:59:03 -0400
X-AuditID: b753bd60-a3089ba000000655-6d-5023277364f2
X-AuditID: b753bd60-a3089ba000000655-6d-5023277364f2
Message-ID: <50232772.4070102@hitachi.com>
Date: Thu, 09 Aug 2012 11:58:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry
 is used
References: <20120807193845.146666357@goodmis.org>  <20120807194059.773895870@goodmis.org> <5021EC6B.7020605@hitachi.com> <1344430148.6935.17.camel@gandalf.stny.rr.com>
In-Reply-To: <1344430148.6935.17.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/08 21:49), Steven Rostedt wrote:
> On Wed, 2012-08-08 at 13:34 +0900, Masami Hiramatsu wrote:
>>  
>>> -#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
>>> +#if defined(CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST) && !defined(CC_USING_FENTRY)
>>
>> I think CONFIG_HAVE_FENTRY would better unselect
>> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST in arch/x86/Kconfig explicitly.
> 
> No, CONFIG_HAVE_FENTRY just means fentry is supported, it does not mean
> that it is being used. It only gets used if CC_USING_FENTRY is set,
> which is set by the Makefile at time of compile.
> 
> If CONFIG_HAVE_FENTRY is defined, a test is done to see if the gcc
> compiling the kernel supports -mfentry. If it does, then it defines the
> CC_USING_FENTRY macro, if not, the macro is not defined and the old way
> is performed.
> 
> If the old way is performed, even if CONFIG_HAVE_FENTRY is defined, then
> we still need the above test. We can not have CONFIG_HAVE_FENTRY
> unselect CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST.

Ah, I see. OK, I don't see any other issue.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


