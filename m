Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2BVPQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:16:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2BVPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:16:00 -0500
Message-ID: <4F450696.6010409@zytor.com>
Date: Wed, 22 Feb 2012 07:15:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com>  <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com>  <20120222074839.GA24890@elte.hu>  <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>  <20120222080659.GA25318@elte.hu>  <1329916920.25686.79.camel@gandalf.stny.rr.com>  <20120222133404.GA14085@elte.hu>  <1329918881.25686.92.camel@gandalf.stny.rr.com>  <20120222145614.GA2491@elte.hu> <1329923533.25686.106.camel@gandalf.stny.rr.com>
In-Reply-To: <1329923533.25686.106.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 07:12 AM, Steven Rostedt wrote:
> On Wed, 2012-02-22 at 15:56 +0100, Ingo Molnar wrote:
> 
>>> Because it really just looks like a stronger "unlikely()" and 
>>> fundamentally it really isn't. [...]
>>
>> Well, the fact is that right now it *is* a stronger unlikely() 
>> on architectures that have jump-labels and it's mapped to 
>> unlikely() on others.
>>
> 
> Has gcc been fix to make it truly an unlikely case and remove the "jmp;
> jmp" problem of before? I'm still using gcc 4.6.0 which has the
> following code for a tracepoint (example is the
> trace_sched_migrate_task().
> 

No, the jmp jmp problem still exists... I have discussed it with the gcc
folks and they have an idea for how to fix it, but I haven't even gotten
around to filing a formal RFE.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

