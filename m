Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1DZXJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:09:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1746 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1DZXJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pszdjerQKRQGCLesMqExJSelDJuB/yUSPEbSVDrJD6g7XxCfjajMW/yyyXTYn6t5fJ
         K3q7iHgvKgu4FmvT7NEg==
Date: Tue, 26 Apr 2011 16:09:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@xenotime.net>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Foley <pefoley2@verizon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
In-Reply-To: <20110426130036.997a05fc.rdunlap@xenotime.net>
Message-ID: <alpine.DEB.2.00.1104261608210.7639@chino.kir.corp.google.com>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Surround the EXPERT menu with "if EXPERT" and "endif" so that it
> is forced to stay as one unit.  Hopefully this will help to prevent
> it being broken in the future.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Peter Foley <pefoley2@verizon.net>
> ---
>  init/Kconfig |   36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
> 
> --- lnx-2639-rc4.orig/init/Kconfig
> +++ lnx-2639-rc4/init/Kconfig
> @@ -924,15 +924,17 @@ menuconfig EXPERT
>            environments which can tolerate a "non-standard" kernel.
>            Only use this if you really know what you are doing.
>  
> +if EXPERT
> +
>  config UID16
> -	bool "Enable 16-bit UID system calls" if EXPERT
> +	bool "Enable 16-bit UID system calls"
>  	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
>  	default y
>  	help
>  	  This enables the legacy 16-bit UID syscall wrappers.
>  

I don't like this, people who look up a Kconfig option typically only 
look at the single entry and look for dependencies within it, not the 
context in which it is declared in the Kconfig file.
