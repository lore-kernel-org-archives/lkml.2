Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2FKHnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2FKHnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:43:10 -0400
Date: Mon, 11 Jun 2012 09:44:34 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [Fw: Re: [PATCH] x86, acpi/irq: Minor readability cleanup of
 gsi_to_irq()]
Message-ID: <20120611074434.GA3383@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This patch probably get lost.
Should I repost?

----- Forwarded message from "Eric W. Biederman" <ebiederm@xmission.com> -----

Date: Fri, 30 Mar 2012 00:15:05 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, acpi/irq: Minor readability cleanup of gsi_to_irq()
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)

Alexander Gordeev <agordeev@redhat.com> writes:

> Init value of 'irq' variable is never used. So do not initialize it.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---

Looks good to me.    I was going to ask what idiot wrote that silly
thing but it appears that idiot was me.    I must have rewritten
the function and forgotten to cleanup that initial assignment to irq.

That change makes it much clearer what is going on thank you.

Eric

>  arch/x86/kernel/acpi/boot.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 406ed77..f148557 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -103,13 +103,11 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
>  
>  static unsigned int gsi_to_irq(unsigned int gsi)
>  {
> -	unsigned int irq = gsi + NR_IRQS_LEGACY;
> -	unsigned int i;
> +	unsigned int irq;
>  
> -	for (i = 0; i < NR_IRQS_LEGACY; i++) {
> -		if (isa_irq_to_gsi[i] == gsi) {
> -			return i;
> -		}
> +	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
> +		if (isa_irq_to_gsi[irq] == gsi)
> +			return irq;
>  	}
>  
>  	/* Provide an identity mapping of gsi == irq

----- End forwarded message -----

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
