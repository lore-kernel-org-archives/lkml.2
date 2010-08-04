Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab0HDOw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:52:29 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43398 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab0HDOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:52:27 -0400
Date: Wed, 4 Aug 2010 10:49:29 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
        hbabu@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: Add vmcoreinfo symbols to allow makdumpfile to
 filter core files properly
Message-ID: <20100804144929.GA13970@hmsreliant.think-freely.org>
References: <20100713134609.GA14514@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713134609.GA14514@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 09:46:09AM -0400, Neil Horman wrote:
> Hey all-
> 	About 2 years ago now, I sent this patch upstream to allow makedumpfile
> to properly filter cores on ppc64:
> http://www.mail-archive.com/kexec@lists.infradead.org/msg02426.html
> It got acks from the kexec folks so I pulled it into RHEL, but I never checked
> back here to make sure it ever made it in, which apparently it didn't.  It still
> needs to be included, so I'm reposting it here, making sure to copy all the ppc
> folks this time.  I've retested it on the latest linus kernel and it works fine,
> allowing makedumpfile to find all the symbols it needs to properly strip a
> vmcore on ppc64.
> 
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  machine_kexec.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> 
> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
> index bb3d893..0df7031 100644
> --- a/arch/powerpc/kernel/machine_kexec.c
> +++ b/arch/powerpc/kernel/machine_kexec.c
> @@ -45,6 +45,18 @@ void machine_kexec_cleanup(struct kimage *image)
>  		ppc_md.machine_kexec_cleanup(image);
>  }
>  
> +void arch_crash_save_vmcoreinfo(void)
> +{
> +
> +#ifdef CONFIG_NEED_MULTIPLE_NODES
> +	VMCOREINFO_SYMBOL(node_data);
> +	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
> +#endif
> +#ifndef CONFIG_NEED_MULTIPLE_NODES
> +	VMCOREINFO_SYMBOL(contig_page_data);
> +#endif
> +}
> +
>  /*
>   * Do not allocate memory (or fail in any way) in machine_kexec().
>   * We are past the point of no return, committed to rebooting now.
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

Ping yet again. Ben, This needs review/acceptance from you or Paul
Neil
