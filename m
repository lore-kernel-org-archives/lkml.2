Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2E2QOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:14:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58055 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2E2QOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:14:20 -0400
Message-ID: <4FC4F5D8.8090701@wwwdotorg.org>
Date: Tue, 29 May 2012 10:14:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, Russell King <rmk@arm.linux.org.uk>
CC: kay.sievers@vrfy.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: arm: Remaining issue with alignment of __log_buf in printk.c
References: <4FC22098.3070803@kernel.org> <4FC25048.109@wwwdotorg.org>
In-Reply-To: <4FC25048.109@wwwdotorg.org>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2012 10:03 AM, Stephen Warren wrote:
> On 05/27/2012 06:39 AM, Jonathan Cameron wrote:
>> Hi All,
>>
>> My stargate 2 board refused to start and after bisection I ended
>> up at the same patch that Stephen found an alignment issue in.
>> Unfortunately Stephen's patch doesn't seem to have fixed the
>> issue for me.
>> https://lkml.org/lkml/2012/5/10/510 is the thread.  Patch from
>> Stephen is : f8450fca6ecdea38b5a882fdf6cd097e3ec8651c
>>
>> Increasing the alignement for 32 bit systems to 8 seems to do the
>> job but I can't immediately think why...
>>
>> System is a pxa27x strong arm.
...
> #if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> #define LOG_ALIGN 4
> #else
> #define LOG_ALIGN 8
> #endif

Actually, why not replace that with:

#define LOG_ALIGN (__alignof__(struct log_buf))

That way, the compiler will calculate the arch-/ABI-appropriate
alignment value automatically and correctly in all cases, so we won't
have to fix that ifdef above.
