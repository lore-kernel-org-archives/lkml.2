Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0JEKjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:39:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27447 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0JEKjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:39:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 05 Oct 2010 12:41:51 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/1] wait: using uninitialized member of wait queue
In-reply-to: <dfd3348b7971bee89360efb85f8d622e6574b003.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: mingo@elte.hu, gregkh@suse.de, a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Message-id: <op.vj3mn1fl7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <dfd3348b7971bee89360efb85f8d622e6574b003.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Oct 2010 10:47:57 +0200, Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com> wrote:
> Member "flags" of "wait_queue_t" struct  is used in several places in
> kernel code without beeing initialized. "flags" is used in bitwise operations.
                       ^^^^^^ -- "being"

> If "flags" not initialized then unexpected behaviour may have place.
> Incorrect flags maybe used later in code.
> Struct "wait_queue_t" is initialized in function "init_wait()". But
> "init_wait()" do not initialize "flag" member.
                 ^^ -- does         ^^^^ -- "flags"

> Added initialization of "wait_queue_t.flags" with zero value into "init_wait".

> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 0836ccc..3efc9f3 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -614,6 +614,7 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
>  		(wait)->private = current;				\
>  		(wait)->func = autoremove_wake_function;		\
>  		INIT_LIST_HEAD(&(wait)->task_list);			\
> +		(wait)->flags = 0;					\
>  	} while (0)
> /**

I'd turn init_wait() into a static inline.  Otherwise looks good to me.
(Interestingly, init_wait() is used only in 3 places in the kernel and
none uses flags.)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
