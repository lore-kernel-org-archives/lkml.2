Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2KZRC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab2KZRCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:23 -0500
Date: Mon, 26 Nov 2012 18:01:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: bigeasy@linutronix.de, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes/powerpc: Make use of generic routines to
	enable single step
Message-ID: <20121126170135.GA8668@redhat.com>
References: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com> <20121126110548.6545.53281.stgit@suzukikp.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126110548.6545.53281.stgit@suzukikp.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Suzuki K. Poulose wrote:
>
> @@ -121,8 +125,11 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	 * to be executed.
>  	 */
>  	regs->nip = utask->vaddr + MAX_UINSN_BYTES;
> +	regs->msr = utask->autask.saved_msr;
> +#ifdef CONFIG_PPC_ADV_DEBUG_REGS
> +	mtspr(SPRN_DBCR0, utask->autask.saved_dbcr);
> +#endif
>  
> -	user_disable_single_step(current);

Don't we need the same change in arch_uprobe_abort_xol() ?

Oleg.

