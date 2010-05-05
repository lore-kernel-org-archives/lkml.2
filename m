Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab0EEMfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0EEMfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:35:03 -0400
Message-ID: <4BE165B0.1070300@redhat.com>
Date: Wed, 05 May 2010 15:33:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, mingo@elte.hu, efault@gmx.de, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>	 <1273050400.1642.229.camel@laptop>  <4BE13B33.3030709@kernel.org>	 <1273053073.1642.235.camel@laptop>  <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop>
In-Reply-To: <1273059488.1642.245.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 02:38 PM, Peter Zijlstra wrote:
> As it stands I'd argue to simply drop this whole idea. The SCHED_EVENT()
> thing doesn't look like its worth the obfuscation and I'm very much
> opposed to making perf and sched_notifiers rely on tracepoints.
>    

We can make perf rely on sched_notifiers, I think it's exactly the same 
case as kvm - extra cpu state that needs switching at context switch 
time.  We could also make fpu switching use sched_notifiers, but that's 
pushing it a bit.

-- 
error compiling committee.c: too many arguments to function

