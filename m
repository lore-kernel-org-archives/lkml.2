Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2A0Jgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:36:49 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37175 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2A0Jgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:36:46 -0500
X-AuditID: b753bd60-98c60ba00000359c-c5-4f22702b5fea
X-AuditID: b753bd60-98c60ba00000359c-c5-4f22702b5fea
Message-ID: <4F227026.3000508@hitachi.com>
Date: Fri, 27 Jan 2012 18:36:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [PATCH RT 1/2 v2] x86: Do not disable preemption in int3 on 32bit
References: <20120125143231.196670014@goodmis.org>   <20120125143520.086175333@goodmis.org> <4F211126.1090204@hitachi.com>  <1327584811.22710.80.camel@gandalf.stny.rr.com>  <4F215C5E.4090006@hitachi.com> <1327587719.22710.95.camel@gandalf.stny.rr.com>
In-Reply-To: <1327587719.22710.95.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/26 23:21), Steven Rostedt wrote:
> On Thu, 2012-01-26 at 22:59 +0900, Masami Hiramatsu wrote:
> 
>> Better. If the functions are only for signaling, how
>> about using the "signal" in name? :)
>>
>> conditional_sti/cli_for_signal()
> 
> I don't think they are only for signals. The conditional_sti/cli is for
> all callers of do_trap(). But those callers that run on an IST stack use
> the preempt_conditional_sti/cli() code. Perhaps we should call it:
> 
> conditional_sti/cli_ist() ?
> 
> Actually, I think this is the best name. The "preempt_" one, didn't give
> any annotation about why it was disabling preemption. It was done
> because the stack is on the IST and we can not schedule out. Thus, if we
> add the "_ist()" to it, not only does it annotate why this call is
> special, but also allows x86_32, which does not have an IST, not to have
> to disable preemption.

I agree with your opinion :)

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
