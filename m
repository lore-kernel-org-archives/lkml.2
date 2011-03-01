Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1CAXZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:25:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab1CAXZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:25:12 -0500
Date: Tue, 1 Mar 2011 15:24:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org, jj@chaosbits.net,
        arnd@arndb.de
Subject: Re: [PATCH] kstrto*: converting strings to integers done
 (hopefully) right
Message-Id: <20110301152455.995eb661.akpm@linux-foundation.org>
In-Reply-To: <20110226124708.GA29242@p183.telecom.by>
References: <20110226124708.GA29242@p183.telecom.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Feb 2011 14:47:08 +0200
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> 1. simple_strto*() do not contain overflow checks and crufty,
>    libc way to indicate failure.
> 2. strict_strto*() also do not have overflow checks but the name and
>    comments pretend they do.
> 3. Both families have only "long long" and "long" variants,
>    but users want strtou8()
> 4. Both "simple" and "strict" prefixes are wrong:
>    Simple doesn't exactly say what's so simple, strict should not exist
>    because conversion should be strict by default.
> 
> The solution is to use "k" prefix and add convertors for more types.
> Enter
> 	kstrtoull()
> 	kstrtoll()
> 	kstrtoul()
> 	kstrtol()
> 	kstrtouint()
> 	kstrtoint()
> 
> 	kstrtou64()
> 	kstrtos64()
> 	kstrtou32()
> 	kstrtos32()
> 	kstrtou16()
> 	kstrtos16()
> 	kstrtou8()
> 	kstrtos8()
> 
> Include runtime testsuite (somewhat incomplete) as well.
> 
> strict_strto*() become deprecated, stubbed to kstrto*() and
> eventually will be removed altogether.

Note that they're deprecated but not marked __deprecated.  That's OK.

> Use kstrto*() in code today!

If you can stomach perl, please prepare a checkpatch patch which alerts
people to the new regime.

> Note: on some archs _kstrtoul() and _kstrtol() are left in tree, even if
>       they'll be unused at runtime. This is temporarily solution,
>       because I don't want to hardcode list of archs where these
>       functions aren't needed. Current solution with sizeof() and
>       __alignof__ at least always works.
> ---
> 
>  Let's merge this into mainline, so I can send individual patches
>  to subsystem maintainers. Whole tree is already converted locally.

Talk to us about the tighter checking.  There's a risk here that
current userspace which "works" will cease to work if we add additional
input checking.  Even if that userspace was broken and
just-happened-to-work, adding additional checks might cause disruption?


