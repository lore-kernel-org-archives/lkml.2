Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3AIQzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:55:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab3AIQzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:55:31 -0500
Date: Wed, 9 Jan 2013 17:28:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v2 4/4] uretprobes: invoke return probe handlers
Message-ID: <20130109162842.GD27722@redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com> <1357730692-3928-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357730692-3928-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Anton Arapov wrote:
>
>  static void handle_swbp(struct pt_regs *regs)
>  {
>  	struct uprobe *uprobe;
> +	struct xol_area *area;
>  	unsigned long bp_vaddr;
>  	int uninitialized_var(is_swbp);
>  
>  	bp_vaddr = uprobe_get_swbp_addr(regs);
> -	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> +	area = get_xol_area();

No, we do not need to allocate xol area here.

> +	if (area) {
> +		if (bp_vaddr == area->vaddr) {
> +			handle_rp_swbp(regs);

Can't understand... this should check bp_vaddr == rp_trampoline_vaddr ?

Again, unless you remove rp_trampoline_vaddr altogether.

Oleg.

