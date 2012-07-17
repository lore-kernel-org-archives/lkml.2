Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2GQArr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 20:47:47 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:34018 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab2GQAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 20:47:44 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2012 20:47:44 EDT
Message-ID: <5004B49C.6010708@cesarb.net>
Date: Mon, 16 Jul 2012 21:41:00 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-mm@kvack.org
Subject: Re: frontswap: is frontswap_init called from swapoff safe?
References: <4FCDE270.1020906@cesarb.net> <20120607003720.GI9472@phenom.dumpdata.com>
In-Reply-To: <20120607003720.GI9472@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-06-2012 21:37, Konrad Rzeszutek Wilk escreveu:
> On Tue, Jun 05, 2012 at 07:41:52AM -0300, Cesar Eduardo Barros wrote:
>> I was looking at the swapfile.c parts of the recently-merged
>> frontswap, and noticed that frontswap_init can be called from
>> swapoff when try_to_unuse fails.
>>
>> This looks odd to me. Whether it is safe or not depends on what
>> frontswap_ops.init does, but the comment for __frontswap_init
>> ("Called when a swap device is swapon'd") and the function name
>> itself seem to imply it should be called only for swapon, not when
>> relinking the swap_info after a failed swapoff.
>
> <nods>
>>
>> In particular, if frontswap_ops.init assumes the swap map is empty,
>> it would break, since as far as I know when try_to_unuse fails there
>> are still pages in the swap.
>
> Let me look at this - can't do it this week - but will get back to you
> shortly.

Did you look at it already? (Just pinging in case you forgot.)

>>
>> (By the way, the comment above enable_swap_info at sys_swapoff needs
>> to be updated to also explain why reading p->frontswap_map outside
>> the lock is safe at that point, like it does for p->prio and
>> p->swap_map.)

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com


