Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0GLHqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 03:46:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:59175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0GLHqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 03:46:05 -0400
Message-ID: <4C3AC826.4010506@kernel.org>
Date: Mon, 12 Jul 2010 09:45:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
References: <4C3A06E3.50402@kernel.org> <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com> <201007121149.58129.rusty@rustcorp.com.au>
In-Reply-To: <201007121149.58129.rusty@rustcorp.com.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 12 Jul 2010 07:45:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

On 07/12/2010 04:19 AM, Rusty Russell wrote:
> Also, is it worth trying to implement this soft disable generically?
> I know at least ppc64 does it today...
> 
> (Y'know, because your initial patch wasn't ambitious enough...)

We can evolve things such that common parts are factored into generic
code but most of important part being heavily dependent on the
specific architecture, I don't think there will be too much (calling
irqhandler on a separate stack if necessary, generic IRQ masking flag
mgmt maybe merged into preemption flag and so on).

Thanks.

-- 
tejun
