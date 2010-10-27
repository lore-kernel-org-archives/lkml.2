Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971Ab0J0Lou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:44:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:50228 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab0J0Los (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:44:48 -0400
Message-ID: <4CC810A0.80609@windriver.com>
Date: Wed, 27 Oct 2010 06:44:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] kdb: avoid on-stack cpumask, old-style accessors
References: <201010272030.34310.rusty@rustcorp.com.au>
In-Reply-To: <201010272030.34310.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 11:44:33.0602 (UTC) FILETIME=[52F90220:01CB75CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 05:00 AM, Rusty Russell wrote:
> That's quite a big stack already; I assume moving it to a static bitmap
> is OK for this usage (a cpumask_var_t might require kmalloc, not sure
> that's a good idea here).
>
>   
Hi Rusty,

This patch seems fine to me, and I'll gladly put it in the merge queue.

The kdb shell has a 2 phase initialization, in order to support early
debugging (before the kernel allocators are ready as well as before
console init).  In the later initialization phase, kmalloc() is
available.  We could return an error up until the structure is allocated
by the kdb late init phase.  It is also possible to avoid allocating the
structure at all if kdb is not configured and free it if you deactivate kdb.

If you are interested or think we should go down that path, let me know.

Thanks,
Jason.

