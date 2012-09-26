Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2IZR4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:56:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2IZR4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:56:37 -0400
Date: Wed, 26 Sep 2012 12:56:29 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 12/14] userns: On ppc convert current_uid from a kuid
 before printing.
Message-ID: <20120926175629.GE30620@sergelap>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-12-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348187330-6616-12-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  arch/powerpc/mm/fault.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 08ffcf5..e5f028b 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -470,7 +470,7 @@ bad_area_nosemaphore:
>  	if (is_exec && (error_code & DSISR_PROTFAULT))
>  		printk_ratelimited(KERN_CRIT "kernel tried to execute NX-protected"
>  				   " page (%lx) - exploit attempt? (uid: %d)\n",
> -				   address, current_uid());
> +				   address, from_kuid(&init_user_ns, current_uid()));
>  
>  	return SIGSEGV;
>  
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
