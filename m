Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1FIRiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:38:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32398 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1FIRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:38:07 -0400
Date: Thu, 9 Jun 2011 10:37:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Doug Thompson <dougthompson@xmission.com>
Cc: linux-kernel@vger.kernel.org, ravi@jetztechnologies.com,
        arvino55@gmail.com, greg@kroah.com, akpm@linux-foundation.org,
        randy.dunlap@oracle.com, joe@perches.com
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
Message-Id: <20110609103747.59805668.randy.dunlap@oracle.com>
In-Reply-To: <20110609030401.GA2615@gmail.com>
References: <20110609030401.GA2615@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DF104F8.0043:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 11:04:13 +0800 Harry Wei wrote:

> From: Harry Wei <harryxiyou@gmail.com>
> 
> When i compile 2.6.39.1, a warning shows like below.
> This patch can fix the warning. And i works well with
> my PC.
> 
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
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
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

But page is still unsigned long, not unsigned long long...

>  	if (info->xeap & 1)
> -		page |= 0x100000000ul;
> +		page |= 0x100000000ull;

and just making this second change fixes the warning.

I don't know what the right answer is, but this patch does not look
complete to me.

Back in April there was a discussion about this warning message and the
conclusion was that this driver should be replaced.  See
https://lkml.org/lkml/2011/4/21/232 and its replies.
But we seem to be having problems reaching the EDAC subsystem maintainer
(again cc-ed).


>  	chan = page & 1;
>  	page >>= 1;
>  	offst = page & ((1 << PAGE_SHIFT) - 1);
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
