Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab2CUSDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:03:42 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61005 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2CUSDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:03:41 -0400
Message-ID: <4F6A17F0.8060204@windriver.com>
Date: Wed, 21 Mar 2012 13:03:28 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdb: Add message about CONFIG_DEBUG_RODATA on failure
 to install breakpoint
References: <4E7A4413.5000307@am.sony.com> <4F68CD32.3040202@windriver.com> <4F68F731.1040908@am.sony.com> <4F68FCE3.5090403@windriver.com>
In-Reply-To: <4F68FCE3.5090403@windriver.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/20/2012 04:55 PM, Jason Wessel wrote:
> 

> Obviously we are not going to go down  the horrible hack route, so I
> thought I might look at how the kprobe implementation works, because
> they  do deal with read-only  pages.  They created a function called
> text_poke() that is called from arch_arm_probe().
>
> It might be possible to take a short cut and use the
> arch_arm_probe() directly.  Ultimately I would like to consider just
> using kprobes instead for things like single stepping etc..., but it
> still has a few problems with atomic reservations.  This work had
> been shelved in back 2010, in favor of merging kdb.  I am not sure
> if anyone wants to take a look at it, but I do think it might
> warrant some experimentation.


To follow up on this and move to closure, I did some investigation and
concluded it is possible to use the kprobes API to make use of the
text_poke() function.

I sent a patch series out for review with the implementation.

https://lkml.org/lkml/2012/3/21/375

Cheers,
Jason.

