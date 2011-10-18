Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1JRXle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:41:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1JRXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:41:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=wtyqlwB7fD+RioB7H/ES1/U4pz4Pw274pPF6byyNUMxJmMsj57w1eBbzC4m1JLxAk
	596W2URarLNrUrWOwGXbg==
Date: Tue, 18 Oct 2011 16:41:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Add TAINT_FIRMWARE_WORKAROUND on MTRR fixup
In-Reply-To: <1318958650-12447-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.00.1110181637400.8149@chino.kir.corp.google.com>
References: <1318958650-12447-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Prarit Bhargava wrote:

> TAINT_FIRMWARE_WORKAROUND should be set when an MTRR fixup is done.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: x86@kernel.org

Acked-by: David Rientjes <rientjes@google.com>

Adding the x86 maintainers to the cc, not sure if x86@kernel.org is 
silently failing (or is it just an alias to them that is already back up 
working)?

> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
> index a71efcd..e1fe7f4 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -547,6 +547,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>  
>  		if (tmp != mask_lo) {
>  			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
> +			add_taint(TAINT_FIRMWARE_WORKAROUND);
>  			mask_lo = tmp;
>  		}
>  	}
