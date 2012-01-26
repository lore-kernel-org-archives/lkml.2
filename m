Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2AZOWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:22:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2AZOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:22:04 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ZvbNAVn_NFoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=94FLRrrtB59VX2iWQHIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327587719.22710.95.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 1/2 v2] x86: Do not disable preemption in int3 on
 32bit
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Date: Thu, 26 Jan 2012 09:21:59 -0500
In-Reply-To: <4F215C5E.4090006@hitachi.com>
References: <20120125143231.196670014@goodmis.org>
	  <20120125143520.086175333@goodmis.org> <4F211126.1090204@hitachi.com>
	 <1327584811.22710.80.camel@gandalf.stny.rr.com>
	 <4F215C5E.4090006@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 22:59 +0900, Masami Hiramatsu wrote:

> Better. If the functions are only for signaling, how
> about using the "signal" in name? :)
> 
> conditional_sti/cli_for_signal()

I don't think they are only for signals. The conditional_sti/cli is for
all callers of do_trap(). But those callers that run on an IST stack use
the preempt_conditional_sti/cli() code. Perhaps we should call it:

conditional_sti/cli_ist() ?

Actually, I think this is the best name. The "preempt_" one, didn't give
any annotation about why it was disabling preemption. It was done
because the stack is on the IST and we can not schedule out. Thus, if we
add the "_ist()" to it, not only does it annotate why this call is
special, but also allows x86_32, which does not have an IST, not to have
to disable preemption.

-- Steve


