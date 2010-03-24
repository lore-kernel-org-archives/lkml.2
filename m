Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0CXScy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:32:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:54727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0CXScw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:32:52 -0400
Message-ID: <4BAA5A7B.8040508@kernel.org>
Date: Wed, 24 Mar 2010 11:31:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4 00/08] use lmb with x86
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org> <20100324104844.GA896@elte.hu>
In-Reply-To: <20100324104844.GA896@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 03:48 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> new early_res is lmb extension. and it could be used to replace bootmem.
> 
> Why not do what we suggested: extend lmb.c to also offer the 
> early_res-equivalent functionality, and remove kernel/early_res.c and move 
> lib/lmb.c to mm/lmb.c?
> 
> We dont want two facilities (early_res and lmb) really ...

the new early_res.c is extension to lmb.

it will
1. add find_lmb_area
2. add check_double_region array with find_lmb_area
3. free_early and reserve_early is wrapper for lmb_free, and lmb_reserve with array size checking
4. some other generizing function like lmb_register_active_regions and lmb_hole_size that could be all lmb users.

so it is seperated file at point.

if lmb guys are happy, we can merge early_res.c and lmb.c. just put them in one file.

Thanks

Yinghai
