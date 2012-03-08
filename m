Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2CHLSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:18:50 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:34196 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2CHLSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:18:45 -0500
Date: Thu, 8 Mar 2012 12:18:28 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, arnd@arndb.de,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 22/29] Disintegrate asm/system.h for S390
Message-ID: <20120308121828.2cdbdc8c@de.ibm.com>
In-Reply-To: <20120307195001.15987.31240.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
	<20120307195001.15987.31240.stgit@warthog.procyon.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12030811-5024-0000-0000-000001EBCFF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2012 19:50:01 +0000
David Howells <dhowells@redhat.com> wrote:

> diff --git a/arch/s390/include/asm/sigp.h b/arch/s390/include/asm/sigp.h
> index 06faf6a..d7008d1 100644
> --- a/arch/s390/include/asm/sigp.h
> +++ b/arch/s390/include/asm/sigp.h
> @@ -14,6 +14,14 @@
>  /* Get real cpu address from logical cpu number. */
>  extern unsigned short __cpu_logical_map[];
> 
> +static inline unsigned short stap(void)
> +{
> +	unsigned short cpu_address;
> +
> +	asm volatile("stap %0" : "=m" (cpu_address));
> +	return cpu_address;
> +}
> +
>  static inline int cpu_logical_map(int cpu)
>  {
>  #ifdef CONFIG_SMP

This hunk will conflict with "[PATCH] rework smp code" in the linux-next
tree. The sigp.h header is disintegrated as well..
But except for this little hiccup I like the idea to split system.h,
makes a lot of sense.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

