Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab0EENKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:10:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:53165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab0EENKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:10:11 -0400
Message-ID: <4BE16DFA.3070204@kernel.org>
Date: Wed, 05 May 2010 15:09:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, efault@gmx.de,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>	 <1273050400.1642.229.camel@laptop>  <4BE13B33.3030709@kernel.org>	 <1273053073.1642.235.camel@laptop>  <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop> <4BE165B0.1070300@redhat.com>
In-Reply-To: <4BE165B0.1070300@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 13:09:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/05/2010 02:33 PM, Avi Kivity wrote:
> On 05/05/2010 02:38 PM, Peter Zijlstra wrote:
>> As it stands I'd argue to simply drop this whole idea. The SCHED_EVENT()
>> thing doesn't look like its worth the obfuscation and I'm very much
>> opposed to making perf and sched_notifiers rely on tracepoints.
> 
> We can make perf rely on sched_notifiers, I think it's exactly the same
> case as kvm - extra cpu state that needs switching at context switch
> time.  We could also make fpu switching use sched_notifiers, but that's
> pushing it a bit.

Oh, that was my first attempt too.  The difference between TPs and
sched_notifiers is the enable condition.  TP is system-wide while
sched_notifier is per-task.  The thing is that for perf hooks,
system-wide enable condition works much better.  Also, w/
sched_notifiers, there's the problem that no one else but self can
enable/disable it (which can be changed but doing it without causing
call time overhead requires a bit of effort).

Thanks.

-- 
tejun
