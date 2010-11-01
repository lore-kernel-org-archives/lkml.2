Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0KANme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:42:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43767 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab0KANmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:42:33 -0400
Message-ID: <4CCEC3B9.1060703@kernel.dk>
Date: Mon, 01 Nov 2010 09:42:17 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using 
 vzalloc rather than vmalloc and memset
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>	<20101030214704.GA20005@Krystal>	<4CCEB723.2010005@kernel.dk>	<20101101130842.GA24605@Krystal> <AANLkTinZaSchq6UKUkiaFTrmdHMpY7x4uN886r7iXeYU@mail.gmail.com>
In-Reply-To: <AANLkTinZaSchq6UKUkiaFTrmdHMpY7x4uN886r7iXeYU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-01 09:41, Pekka Enberg wrote:
> * Jens Axboe (axboe@kernel.dk) wrote:
>>> On 2010-10-30 17:47, Mathieu Desnoyers wrote:
>>>> BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
>>>> transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
>>>> relay dependency to the Generic Ring Buffer Library might be a good
>>>> option to consider.
>>>
>>> The blktrace user bits is still (by far) the most wide spread way that
>>> blktrace is used in the field, and those still rely on relayfs. So no,
>>> we can't kill it now.
> 
> On Mon, Nov 1, 2010 at 3:08 PM, Mathieu Desnoyers
> <mathieu.desnoyers@polymtl.ca> wrote:
>> What I am proposing is that the Generic Ring Buffer Library could
>> replace relayfs without changing any of the interfaces blktrace exposes
>> to user-space. Indeed, I would not remove relayfs unless there was a
>> replacement.
> 
> We don't in general NAK cleanups because of future features or
> removals that may or may not happen.

Agree, this is parallel to whether or not we can transition blktrace to
using the generic ring buffer library or not. If the current patch
proposed makes sense, then it should go in regardless of
potential/future plans.

-- 
Jens Axboe

