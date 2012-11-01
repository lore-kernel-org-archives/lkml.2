Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2KAI5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 04:57:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63659 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab2KAI5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 04:57:05 -0400
Message-ID: <50923956.5090206@gmail.com>
Date: Thu, 01 Nov 2012 16:56:54 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
References: <509109F9.3030904@gmail.com> <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com>
In-Reply-To: <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/1 1:35:
> It would be better to use
> 
> 	this_cpu_read(tfms)
> 
> since that would also make it atomic vs interrupts. The above code (both
> original and modified) could determine a pointer to a per cpu structure
> and then take an interrupt which would move the task. On return we would
> be accessing the per cpu variable of another processor.

this_cpu_read
|-----_this_cpu_generic_read

#define _this_cpu_generic_read(pcp)                                     \
({      typeof(pcp) ret__;                                              \
        preempt_disable();                                              \
        ret__ = *this_cpu_ptr(&(pcp));                                  \
        preempt_enable();                                               \
        ret__;                                                          \
})


this_cpu_read operations locate per-cpu variable with preemption safe， not
disable interrupts. why is it atomic vs interrupts?

I have no idea whether we need to disable preemption for this code?
At least, xfrm code run well with per_cpu_ptr which don't disable preemption.

