Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab1JaWyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:54:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934709Ab1JaWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:54:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=I2LiYIy5otpsBjEMJ8N/pdOXk6xcvXsBLC94z+s4qp1f+G3zqNe6JNwkDD8ESBm0c
	BYfbuNypQqco05vdhlxPQ==
Date: Mon, 31 Oct 2011 15:54:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [RFC/PATCH 3/7] x86, mm: Use max_pfn instead of highend_pfn
In-Reply-To: <1319811801-1725-3-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1110311552280.22237@chino.kir.corp.google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org> <1319811801-1725-3-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Pekka Enberg wrote:

> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 434c97d..6101894 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -54,7 +54,7 @@
>  #include <asm/page_types.h>
>  #include <asm/init.h>
>  
> -unsigned long highstart_pfn, highend_pfn;
> +unsigned long highstart_pfn;
>  
>  static noinline int do_test_wp_bit(void);
>  

This shouldn't build with a CONFIG_NUMA i386 config, highend_pfn is used 
in arch/x86/mm/numa_32.c.
