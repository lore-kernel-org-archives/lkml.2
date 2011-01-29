Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1A2Vax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:30:53 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21639 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1A2Vax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:30:53 -0500
Date: Sat, 29 Jan 2011 22:32:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Michael Rodriguez <dkingston02@gmail.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/cpu.c: Fix many errors related to style.
In-Reply-To: <1296332359-21389-1-git-send-email-dkingston02@gmail.com>
Message-ID: <alpine.LNX.2.00.1101292229270.19392@swampdragon.chaosbits.net>
References: <1296332359-21389-1-git-send-email-dkingston02@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jan 2011, Michael Rodriguez wrote:

> This patch changes the printk() calls to have the KERN_INFO/KERN_ERROR stuff,
> and fixes other coding style errors. Not _all_ of them are gone, though.
> 
> Signed-off-by: Michael Rodriguez <dkingston02@gmail.com>
> ---
>  kernel/cpu.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
...
> @@ -201,11 +200,11 @@ static int __ref take_cpu_down(void *_param)
>  
>  	/* Ensure this CPU doesn't handle any more interrupts. */
>  	err = __cpu_disable();
> +
>  	if (err < 0)
>  		return err;
Why? We set 'err', then we test 'err' - why do we need a blank line 
between those two? It's not like you are sepperating two logically 
different operations from eachother here...

...
> @@ -227,7 +226,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  		return -EINVAL;
>  
>  	cpu_hotplug_begin();
> +
>  	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
> +
>  	if (err) {
>  		nr_calls--;
>  		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);

Why would we want these extra newlines? What's the point? The opereations 
fit nicely together, I don't see the point in adding these extra 
newlines..


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

