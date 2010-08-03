Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0HCSZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:25:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57336 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392Ab0HCSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:25:10 -0400
Date: Tue, 3 Aug 2010 11:23:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        akpm@linux-foundation.org, sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [PATCH] kernel: rounddown helper function
Message-Id: <20100803112354.8761e49d.randy.dunlap@oracle.com>
In-Reply-To: <20100803181607.30614.36916.stgit@paris.rdu.redhat.com>
References: <20100803181607.30614.36916.stgit@paris.rdu.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C585ED3.028D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 14:16:07 -0400 Eric Paris wrote:

> The roundup() helper function will round a given value up to a multiple of
> another given value.  aka  roundup(11, 7) would give 14 = 7 * 2.  This new
> function does the opposite.  It will round a given number down to the
> nearest multiple of the second number: rounddown(11, 7) would give 7.
> 
> I need this in some future SELinux code and can carry the macro myself, but
> figured I would put it in the core kernel so others might find and use it
> if need be.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  include/linux/kernel.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 7d5b10f..d6092fd 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -59,6 +59,7 @@ extern const char linux_proc_banner[];
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> +#define rounddown(x, y) ((x) - ((x) % (y)))
>  #define DIV_ROUND_CLOSEST(x, divisor)(			\
>  {							\
>  	typeof(divisor) __divisor = divisor;		\
> 
> --

I'm more used to seeing it like

#define DIV_ROUND_DOWN(n, d)	(((n) / (d)) * (d))

but since multiply/divide/modulus are usually slower, your (SELinux) way is better,
I suppose.

and the usual caveats apply:  don't use these macros with expressions (nor with y
or d == 0).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
