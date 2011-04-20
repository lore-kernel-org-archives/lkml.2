Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1DTVFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:05:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1DTVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=O96TLdF9sL0dqxT3wkIpS8ejD3khCTOfIrzKwRLs+KRZSaPK846T275CPCatGR3Yoz
         PAEgNYSE8dFFIrR3rUCQ==
Date: Wed, 20 Apr 2011 14:05:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110420174027.4631.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104201403060.31768@chino.kir.corp.google.com>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420174027.4631.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, KOSAKI Motohiro wrote:

> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index 69ff049..0bf9ae8 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -229,6 +229,12 @@ config HOTPLUG_CPU
>  	default y if SMP
>  	select HOTPLUG
>  
> +config NUMA
> +	bool "NUMA support"
> +	help
> +	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
> +	  Access).
> +
>  config ARCH_SELECT_MEMORY_MODEL
>  	def_bool y
>  	depends on 64BIT
> @@ -236,6 +242,7 @@ config ARCH_SELECT_MEMORY_MODEL
>  config ARCH_DISCONTIGMEM_ENABLE
>  	def_bool y
>  	depends on 64BIT
> +	depends on NUMA
>  
>  config ARCH_FLATMEM_ENABLE
>  	def_bool y

I think this should probably be

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -244,6 +244,9 @@ config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
+config NUMA
+	def_bool ARCH_DISCONTIGMEM_ENABLE
+
 config NODES_SHIFT
 	int
 	default "3"

instead since we don't need CONFIG_NUMA for anything other than 
CONFIG_PA8X00 and 64-bit enabled.
