Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1BJRjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:39:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35000 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1BJRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:39:08 -0500
Date: Thu, 10 Feb 2011 09:38:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: gregkh@suse.de
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] kobject.h: fix build when CONFIG_HOTPLUG is
 disabled
Message-Id: <20110210093847.995e6f97.randy.dunlap@oracle.com>
In-Reply-To: <20110206215718.185b6262.randy.dunlap@oracle.com>
References: <20110207161902.a4c36e08.sfr@canb.auug.org.au>
	<20110206215718.185b6262.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D5422B0.0085:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011 21:57:18 -0800 Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_HOTPLUG is not enabled, the inline function add_uevent_var()
> needs to have its __attribute__ before the function name/parameters,
> otherwise there are syntax errors.
> 
> linux-next-20110207/include/linux/kobject.h:232: error: expected ',' or ';' before '{' token
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Greg,
This patch is still needed in linux-next, please...


> ---
>  include/linux/kobject.h |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- linux/include/linux/kobject.h.ORG	2011-02-06 21:47:23.000000000 -0800
> +++ linux/include/linux/kobject.h	2011-02-06 21:44:56.000000000 -0800
> @@ -226,9 +226,8 @@
>  				      char *envp[])
>  { return 0; }
>  
> -static inline int add_uevent_var(struct kobj_uevent_env *env,
> -				 const char *format, ...)
> -	__attribute__((format(printf, 2, 3)))
> +static inline __attribute__((format(printf, 2, 3)))
> +int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
>  { return 0; }
>  
>  static inline int kobject_action_type(const char *buf, size_t count,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
