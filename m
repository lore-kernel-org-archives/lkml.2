Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0CWPMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:12:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18729 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab0CWPMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:12:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=wzWtAfsM8FG97Yzuw+l16X0DrlvZY904bwpEBfZmiuJRTmbmcBcOjP9YofY+0ZiR5
	P3LQYnfRmwE0YdvkmlAOA==
MIME-Version: 1.0
In-Reply-To: <1269356868.5109.66.camel@twins>
References: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
	 <1268869631.9440.282.camel@laptop>
	 <bd4cb8901003171733k95fcf50mf6de78bf503d9a7b@mail.gmail.com>
	 <1269353485.5109.48.camel@twins>
	 <bd4cb8901003230755k41414173n302d7d626a6126b1@mail.gmail.com>
	 <1269356868.5109.66.camel@twins>
Date: Tue, 23 Mar 2010 16:12:39 +0100
Message-ID: <bd4cb8901003230812s777fcd77x6ffff63123039070@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in AMD per-cpu initialization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo <mingo@elte.hu>, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       "hpa@zytor.com" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 4:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-03-23 at 15:55 +0100, Stephane Eranian wrote:
>> What's the point of CPU_ONLINE vs. CPU_STARTING if you're saying the
>> former is never right? Why not move CPU_ONLINE to the right place and
>> drop CPU_STARTING?
>
> Its right for a lot of things, just not for perf, we need to be ready
> and done by the time the cpu starts scheduling.
>
You mean they need to wait until after the cpu starts scheduling?
As opposed to being called just before it starts scheduling.
