Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2HUO0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2HUO0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:26:31 -0400
Message-ID: <50339A85.3080206@redhat.com>
Date: Tue, 21 Aug 2012 17:26:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: Link Time Optimization support for the kernel
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <20120820074835.GA6710@gmail.com> <20120820101044.GE16230@one.firstfloor.org> <20120821074921.GA10809@gmail.com>
In-Reply-To: <20120821074921.GA10809@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 10:49 AM, Ingo Molnar wrote:
> 
> Can the current implementation of LTO optimize to the level of 
> inlining? A lot of our include file hell situation results from 
> the desire to declare structures publicly so that inlined 
> functions can use them directly.
> 
> If data structures could be encapsulated/internalized to 
> subsystems and only global functions are exposed to other 
> subsystems [which are then LTO optimized] then our include
> file dependencies could become a *lot* simpler.

I think modules break this (if I understand what you mean correctly).
If the main kernel exposes symbol x as a global function, then lto will
not inline it into a module.

-- 
error compiling committee.c: too many arguments to function
