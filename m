Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1EEHbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:31:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59191 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1EEHbs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 5 May 2011 03:31:48 -0400
Message-Id: <4DC26E82020000780003FC51@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 05 May 2011 08:31:46 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Daniel Kiper" <dkiper@net-space.pl>
Cc: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/8] arch/x86/xen/irq: Cleanup
	 code/data sections definitions
References: <20110504181607.GC29218@router-fw-old.local.net-space.pl>
In-Reply-To: <20110504181607.GC29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.05.11 at 20:16, Daniel Kiper <dkiper@net-space.pl> wrote:
> Cleanup code/data sections definitions
> accordingly to include/linux/init.h.

I'm not clear what the motivation for this patch series is in the first
place, but I'm particularly unhappy with following inconsistent
guidelines: The placement suggestion for function and data
definitions are not in sync - the annotation is said to go between
type and name for functions, but after the name for data, yet
there's no reason known to me why the rule for data can't be the
same as that for functions (the other way around doesn't work,
as gcc's documentation says that for function definitions (other
than for their declarations) attributes cannot currently follow the
declarator.

So I'd rather think the guidelines should first be made consistent
(or it should be explained why they must be different), and then
the users of those annotations should get updated.

Jan

> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> ---
>  arch/x86/xen/irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> index 6a6fe89..8bbb465 100644
> --- a/arch/x86/xen/irq.c
> +++ b/arch/x86/xen/irq.c
> @@ -113,7 +113,7 @@ static void xen_halt(void)
>  		xen_safe_halt();
>  }
>  
> -static const struct pv_irq_ops xen_irq_ops __initdata = {
> +static const struct pv_irq_ops xen_irq_ops __initconst = {
>  	.save_fl = PV_CALLEE_SAVE(xen_save_fl),
>  	.restore_fl = PV_CALLEE_SAVE(xen_restore_fl),
>  	.irq_disable = PV_CALLEE_SAVE(xen_irq_disable),




