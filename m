Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0ICB3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:29:54 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:61650 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751281Ab0ICB3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:29:53 -0400
Message-ID: <4C804F7D.5090105@snapgear.com>
Date: Fri, 3 Sep 2010 11:29:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Drop a couple of unnecessary asm/include.h inclusions
References: <19747.1283422807@redhat.com> <20100902102153.19806.82031.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100902102153.19806.82031.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 01:29:51.0332 (UTC) FILETIME=[811EBA40:01CB4B07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Drop inclusions of asm/include.h from linux/hardirq.h and linux/list.h as
> they're no longer required and prevent the M68K arch's IRQ flag handling macros
> from being made into inlined functions due to circular dependencies.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
> 
>  include/linux/hardirq.h |    1 -
>  include/linux/list.h    |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index d5b3876..7dfdc06 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -8,7 +8,6 @@
>  #include <linux/lockdep.h>
>  #include <linux/ftrace_irq.h>
>  #include <asm/hardirq.h>
> -#include <asm/system.h>
>  
>  /*
>   * We put the hardirq and softirq counter into the preemption
> diff --git a/include/linux/list.h b/include/linux/list.h
> index d167b5d..88a0006 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -5,7 +5,6 @@
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
>  #include <linux/prefetch.h>
> -#include <asm/system.h>
>  
>  /*
>   * Simple doubly linked list implementation.
> 
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
