Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab0CSDBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:01:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42117
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab0CSDBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:01:45 -0400
Date: Thu, 18 Mar 2010 20:02:05 -0700 (PDT)
Message-Id: <20100318.200205.59696640.davem@davemloft.net>
To: tj@kernel.org
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA2DF0B.9080600@kernel.org>
References: <20100319013119.GB22095@nowhere>
	<20100318.185757.39197211.davem@davemloft.net>
	<4BA2DF0B.9080600@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 19 Mar 2010 11:18:51 +0900

> On 03/19/2010 10:57 AM, David Miller wrote:
>> I would use u64 so something like:
>> 
>> 	u64 [FTRACE_MAX_PROFILE_SIZE / sizeof(u64)]
> 
> <paranoid>DIV_ROUND_UP() would be safer than division</paranoid>

There's potential real trouble if it isn't a multiple of sizeof(u64)
so better:

	BUILD_BUG_ON(FTRACE_MAX_PROFILE_SIZE % sizeof(u64));

:-)

What a mess, just because this thing can't be typed properly :-/
