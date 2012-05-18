Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab2ERSmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:42:20 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:52679 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2ERSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:42:19 -0400
Date: Fri, 18 May 2012 20:42:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: make asm-generic/kvm_para.h have an ifdef
	__KERNEL__ block
Message-ID: <20120518184217.GA17367@merkur.ravnborg.org>
References: <1337363979-5121-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337363979-5121-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 01:59:39PM -0400, Paul Gortmaker wrote:
> There are two functions in this asm-generic file.  Looking at
> other arch which do not use the generic version, these two fcns
> are within an #ifdef __KERNEL__ block, so make the generic one
> consistent with those.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
> index 9a7bbad..5cba37f 100644
> --- a/include/asm-generic/kvm_para.h
> +++ b/include/asm-generic/kvm_para.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_GENERIC_KVM_PARA_H
>  #define _ASM_GENERIC_KVM_PARA_H
>  
> +#ifdef __KERNEL__
>  
>  /*
>   * This function is used by architectures that support kvm to avoid issuing
> @@ -16,4 +17,6 @@ static inline unsigned int kvm_arch_para_features(void)
>  	return 0;
>  }
>  
> +#endif	/* _KERNEL__ */
> +
>  #endif

I do not have this file in my tree...
But in general we should try to separate out exporeted stuff in their own headers,
so no new files should ever use __KERNEL__.

Either everything or nothing is exported.

	Sam
