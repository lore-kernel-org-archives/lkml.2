Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0JWPnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:43:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab0JWPnI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <20101023152959.GA20930@elte.hu>
References: <4CC143F5.3060202@fusionio.com> <20101023152959.GA20930@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Oct 2010 08:42:37 -0700
Message-ID: <AANLkTimwW1=z0Z1xX9ZgQWS+CcKocWwDAc2qFPq44gtA@mail.gmail.com>
Subject: Re: [origin tree boot failure] Re: [GIT PULL] core block bits for 2.6.37-rc1
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 8:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> [  116.080274]
> [  116.080274] Pid: 1, comm: swapper Tainted: G        W   2.6.36-tip-03555-g825d9ec-dirty #51843 A8N-E/System Product Name
> [  116.080274] RIP: 0010:[<ffffffff81064380>]  [<ffffffff81064380>] __ticket_spin_trylock+0x4/0x21
> [  116.080274] RSP: 0018:ffff88003c417c10  EFLAGS: 00010082
> [  116.080274] RAX: ffff88003c418000 RBX: 6b6b6b6b6b6b6b6a RCX: 0000000000000000
> [  116.080274] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6b6a
> [  116.080274] RBP: ffff88003c417c10 R08: 0000000000000002 R09: 0000000000000001
> [  116.080274] R10: 0000000000000286 R11: ffff880032498738 R12: 6b6b6b6b6b6b6b82

And we obviously have that "6b" pattern for a use-after free with slab
poisoning. Jens, have you tried with slab debugging?

                    Linus
