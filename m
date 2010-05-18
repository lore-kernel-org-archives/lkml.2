Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab0ERSQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:16:07 -0400
Received: from claw.goop.org ([74.207.240.146]:59817 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718Ab0ERSPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:15:55 -0400
Message-ID: <4BF2D95B.2040007@goop.org>
Date: Tue, 18 May 2010 11:15:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 09/12] Fix possible NULL pointer dereference in print_IO_APIC
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-9-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1274178187-20602-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 03:23 AM, Stefano Stabellini wrote:
> Make sure chip_data is not NULL before accessing it.
>   

You should clarify under what circumstances it can be legitimately NULL.

    J

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index eb2789c..c64499c 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1732,6 +1732,8 @@ __apicdebuginit(void) print_IO_APIC(void)
>  		struct irq_pin_list *entry;
>  
>  		cfg = desc->chip_data;
> +		if (!cfg)
> +			continue;
>  		entry = cfg->irq_2_pin;
>  		if (!entry)
>  			continue;
>   

