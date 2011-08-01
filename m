Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1HAURE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab1HAUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:16:57 -0400
Date: Mon, 1 Aug 2011 16:16:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 01/10] kdump: Add KEXEC_CRASH_CONTROL_MEMORY_LIMIT
Message-ID: <20110801201644.GG3805@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
 <20110727125807.529303146@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727125807.529303146@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 02:55:05PM +0200, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> On s390 there is a different KEXEC_CONTROL_MEMORY_LIMIT for the normal and
> the kdump kexec case. Therefore this patch introduces a new macro
> KEXEC_CRASH_CONTROL_MEMORY_LIMIT. This is set to
> KEXEC_CONTROL_MEMORY_LIMIT for all architectures that do not define
> KEXEC_CRASH_CONTROL_MEMORY_LIMIT.

Hi Michael,

Curious that why limit is different for kexec and kdump cases on s390
only.

Thanks
Vivek

> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  include/linux/kexec.h |    4 ++++
>  kernel/kexec.c        |    2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -33,6 +33,10 @@
>  #error KEXEC_ARCH not defined
>  #endif
>  
> +#ifndef KEXEC_CRASH_CONTROL_MEMORY_LIMIT
> +#define KEXEC_CRASH_CONTROL_MEMORY_LIMIT KEXEC_CONTROL_MEMORY_LIMIT
> +#endif
> +
>  #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
>  #define KEXEC_CORE_NOTE_NAME "CORE"
>  #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -498,7 +498,7 @@ static struct page *kimage_alloc_crash_c
>  	while (hole_end <= crashk_res.end) {
>  		unsigned long i;
>  
> -		if (hole_end > KEXEC_CONTROL_MEMORY_LIMIT)
> +		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
>  			break;
>  		if (hole_end > crashk_res.end)
>  			break;
