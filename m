Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab1FFUhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:37:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19857 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1FFUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:37:17 -0400
Date: Mon, 6 Jun 2011 13:36:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, ravi@jetztechnologies.com,
        arvino55@gmail.com, bluesmoke-devel@lists.sourceforge.net,
        greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH]Remove a warning for drivers/edac/i82975x_edac.c
Message-Id: <20110606133652.1d146bba.randy.dunlap@oracle.com>
In-Reply-To: <20110604022151.GA2475@gmail.com>
References: <20110604022151.GA2475@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DED3A71.0072:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jun 2011 10:22:21 +0800 Harry Wei wrote:

> From: Harry Wei <harryxiyou@gmail.com>
> 
> When i compile 2.6.39.1, a warning shows like below.
> This patch can fix the warning. And i works well with
> my PC.

Hi Harry,

Does "works well with my PC" mean that you boot-tested this patch
or just compile-tested it?

and if you boot-tested it, do you have hardware that actually
exercises this code path?

> [...]
> CC [M]  drivers/edac/e752x_edac.o
> CC [M]  drivers/edac/i82875p_edac.o
> CC [M]  drivers/edac/i82975x_edac.o
> drivers/edac/i82975x_edac.c: In function ���i82975x_process_error_info���:
> drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for ���unsigned long��� type
> CC [M]  drivers/edac/i3000_edac.o
> CC [M]  drivers/edac/i3200_edac.o
> CC [M]  drivers/edac/x38_edac.o
> CC [M]  drivers/edac/i82860_edac.o
> [...]
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> 
> Index: prj/drivers/edac/i82975x_edac.c
> ===================================================================
> --- prj.orig/drivers/edac/i82975x_edac.c	2011-06-04 10:09:55.351174516 +0800
> +++ prj/drivers/edac/i82975x_edac.c	2011-06-04 10:10:30.875168437 +0800
> @@ -293,9 +293,9 @@
>  		info->errsts = info->errsts2;
>  	}
>  
> -	page = (unsigned long) info->eap;
> +	page = (unsigned long long) info->eap;

but page is still declared as unsigned long.  should it be unsigned long long?

>  	if (info->xeap & 1)
> -		page |= 0x100000000ul;
> +		page |= 0x100000000ull;
>  	chan = page & 1;
>  	page >>= 1;
>  	offst = page & ((1 << PAGE_SHIFT) - 1);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
