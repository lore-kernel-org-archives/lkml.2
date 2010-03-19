Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0CSB5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:57:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39738
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab0CSB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:57:35 -0400
Date: Thu, 18 Mar 2010 18:57:57 -0700 (PDT)
Message-Id: <20100318.185757.39197211.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: tj@kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100319013119.GB22095@nowhere>
References: <4BA1F2BA.30604@kernel.org>
	<20100318.175413.183069013.davem@davemloft.net>
	<20100319013119.GB22095@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 19 Mar 2010 02:31:22 +0100

> On Thu, Mar 18, 2010 at 05:54:13PM -0700, David Miller wrote:
>> From: Tejun Heo <tj@kernel.org>
>> Date: Thu, 18 Mar 2010 18:30:34 +0900
>> 
>> >  
>> >  	if (!total_profile_count) {
>> > -		buf = (char *)alloc_percpu(perf_trace_t);
>> > +		buf = (char *)__alloc_percpu(sizeof(perf_trace_t),
>> > +					     __alignof__(unsigned long));
>> >  		if (!buf)
>> >  			goto fail_buf;
>> 
>> Why not make perf_trace_t have the proper alignment?
> 
> 
> So, making perf_trace_t as align(8) would do the trick?
> I lack the knowledge about alignment layout for archs that
> need aligned accesses.
> At a first glance, what I would except is that every buffer
> has a base address aligned, no?

Make it of the largest type that could appeat
in a trace entry.

I would use u64 so something like:

	u64 [FTRACE_MAX_PROFILE_SIZE / sizeof(u64)]
