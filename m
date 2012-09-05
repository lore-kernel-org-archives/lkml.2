Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab2IEVQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:16:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54427 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501Ab2IEVQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:16:06 -0400
Message-ID: <1346879629.2054.22.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Wed, 05 Sep 2012 17:13:49 -0400
In-Reply-To: <1346774117-2277-8-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	 <1346774117-2277-8-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090521-6148-0000-0000-000009512C86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 11:55 -0400, Matthew Garrett wrote:
> kexec could be used as a vector for a malicious user to use a signed kernel
> to circumvent the secure boot trust model. In the long run we'll want to
> support signed kexec payloads, but for the moment we should just disable
> loading entirely in that situation.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  kernel/kexec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 0668d58..48852ec 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -944,7 +944,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  	int result;
> 
>  	/* We only trust the superuser with rebooting the system. */
> -	if (!capable(CAP_SYS_BOOT))
> +	if (!capable(CAP_SYS_BOOT) || !capable(CAP_SECURE_FIRMWARE))
>  		return -EPERM;
> 
>  	/*

Normally capabilities provide additional permissions. So if you don't
have the capability, an errno is returned.  CAP_SYS_BOOT is a good
example.  With CAP_SECURE_FIRMWARE, it reads backwards - if not
CAP_SECURE_FIRMWARE, return error.  I think you want to invert the name
to CAP_NOT_SECURE_FIRMWARE, CAP_NOT_SECURE_BOOT or perhaps
CAP_UNSECURED_BOOT.

Mimi

