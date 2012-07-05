Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2GERVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:21:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19745 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GERV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:21:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 05 Jul 2012 10:21:23 -0700
Message-ID: <4FF5CD0D.7030902@nvidia.com>
Date: Thu, 5 Jul 2012 22:51:17 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: Fix cached parent ptrs allocation
References: <1341407737-1016-1-git-send-email-pgaikwad@nvidia.com> <4FF5BBD3.6080704@wwwdotorg.org>
In-Reply-To: <4FF5BBD3.6080704@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012 09:37 PM, Stephen Warren wrote:
> On 07/04/2012 07:15 AM, Prashant Gaikwad wrote:
>> Compiler optimizes code someway that even if clk->parents
>> is not NULL it tries to allocate parents array. Change the
>> condition so that compiler does not optimize it in wrong
>> way.
> If simply inverting the if test and swapping the if/else blocks solves
> some problem, that sounds like a compiler bug that we need to track down
> and file/fix.
>
>> Also, initialize i to num_parents to make sure parent
>> is searched using parent name if parents is NULL.
> Are you sure the change to initialize i wasn't all that was required to
> solve the problem though? Mike has applied a patch for this that'll be
> applied to 3.5-rcX and hence trickle into 3.6.
Just initializing i does not fix problem. The patch Mike has applied 
does two things
1. remove warning for uninitialized i
2. invert the if test
