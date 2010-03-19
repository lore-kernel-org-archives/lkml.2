Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0CSAxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:53:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54480
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab0CSAxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:53:51 -0400
Date: Thu, 18 Mar 2010 17:54:13 -0700 (PDT)
Message-Id: <20100318.175413.183069013.davem@davemloft.net>
To: tj@kernel.org
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA1F2BA.30604@kernel.org>
References: <20100318044930.GC5045@nowhere>
	<4BA1F2BA.30604@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 18 Mar 2010 18:30:34 +0900

>  
>  	if (!total_profile_count) {
> -		buf = (char *)alloc_percpu(perf_trace_t);
> +		buf = (char *)__alloc_percpu(sizeof(perf_trace_t),
> +					     __alignof__(unsigned long));
>  		if (!buf)
>  			goto fail_buf;

Why not make perf_trace_t have the proper alignment?

That's better than patching around it like this.

Defining it as an array of char[]'s is just asking
for lots of trouble.
