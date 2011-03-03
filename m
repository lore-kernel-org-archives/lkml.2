Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1CCUwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:52:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1CCUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=THFXGEHOsSN+Dd9CSbnAm0/2Mi7XTyc6jqHd8INLktCCUgYX8na7USRTGIFkX0xzlE
         plt5Lwa8HBU3nAcsWIgA==
Date: Thu, 3 Mar 2011 12:52:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: move bootnode definition into srat_64.c
In-Reply-To: <4D6EECE8.80500@kernel.org>
Message-ID: <alpine.DEB.2.00.1103031251460.9993@chino.kir.corp.google.com>
References: <4D6EECE8.80500@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Yinghai Lu wrote:

> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index 8e9d339..7e5d0e9 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -26,6 +26,11 @@
>  
>  int acpi_numa __initdata;
>  
> +struct bootnode {
> +	u64 start;
> +	u64 end;
> +};
> +
>  static struct bootnode nodes_add[MAX_NUMNODES];
>  
>  static __init int setup_node(int pxm)

Can we get rid of struct bootnode instead and simply reuse 
struct numa_memblk?  The latter isn't actually tied to memblock and is a 
generic representation of a node id and address range.
