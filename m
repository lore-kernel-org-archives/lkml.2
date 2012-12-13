Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2LMQlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:41:17 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:37324 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2LMQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:41:14 -0500
Message-ID: <50CA0529.2050506@tilera.com>
Date: Thu, 13 Dec 2012 11:41:13 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
References: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com> <20121212234307.GA7694@redhat.com> <50C9ECFF.6070708@tilera.com> <20121213154929.GA17421@redhat.com> <50C9FF11.2030303@tilera.com> <20121213162710.GA20271@redhat.com>
In-Reply-To: <20121213162710.GA20271@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 11:27 AM, Oleg Nesterov wrote:
> On 12/13, Chris Metcalf wrote:
>> On 12/13/2012 10:49 AM, Oleg Nesterov wrote:
>>> But ptrace_setoptions() returns EINVAL? it doesn't accept illegal bits.
>> It does return EINVAL - but if it gets both legal and illegal bits,
>> it honors all the legal bits first.
> This was true in the past, but now we have
>
> 	static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> 	{
> 		unsigned flags;
>
> 		if (data & ~(unsigned long)PTRACE_O_MASK)
> 			return -EINVAL;
>
> 		/* Avoid intermediate state when all opts are cleared */
> 		flags = child->ptrace;
> 		flags &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
> 		flags |= (data << PT_OPT_FLAG_SHIFT);
> 		child->ptrace = flags;
>
> 		return 0;
> 	}

Yup, I was looking at an older version of the code by mistake.  See patch to follow.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

