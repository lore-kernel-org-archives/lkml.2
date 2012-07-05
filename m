Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab2GESoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:44:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51736 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab2GESoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:44:05 -0400
Message-ID: <4FF5E071.3090106@wwwdotorg.org>
Date: Thu, 05 Jul 2012 12:44:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: Fix cached parent ptrs allocation
References: <1341407737-1016-1-git-send-email-pgaikwad@nvidia.com> <4FF5BBD3.6080704@wwwdotorg.org> <4FF5CD0D.7030902@nvidia.com>
In-Reply-To: <4FF5CD0D.7030902@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 11:21 AM, Prashant Gaikwad wrote:
> On Thursday 05 July 2012 09:37 PM, Stephen Warren wrote:
>> On 07/04/2012 07:15 AM, Prashant Gaikwad wrote:
>>> Compiler optimizes code someway that even if clk->parents
>>> is not NULL it tries to allocate parents array. Change the
>>> condition so that compiler does not optimize it in wrong
>>> way.
>> If simply inverting the if test and swapping the if/else blocks solves
>> some problem, that sounds like a compiler bug that we need to track down
>> and file/fix.
>>
>>> Also, initialize i to num_parents to make sure parent
>>> is searched using parent name if parents is NULL.
>> Are you sure the change to initialize i wasn't all that was required to
>> solve the problem though? Mike has applied a patch for this that'll be
>> applied to 3.5-rcX and hence trickle into 3.6.
>
> Just initializing i does not fix problem. The patch Mike has applied
> does two things
> 1. remove warning for uninitialized i
> 2. invert the if test

Yes, but Mike's patch is very different to yours. Your patch description
says that you need to invert the if test to work around the compiler
optimizer so that it doesn't "optimize it in wrong way", whereas the
patch Mike applied was for a legitimate bug in the code; those are two
entirely different things.
