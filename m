Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2DCQwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:52:33 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:48113
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab2DCQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:52:32 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bhz2dh668h839hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1WXJ9-01-IS8-02
X-M-MSG: 
Message-ID: <4F7B2AC3.3060706@amd.com>
Date: Tue, 3 Apr 2012 12:52:19 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] Use safe_halt() rather than halt() in acpi_idle_play_deay()
References: <4f7b27487632dad07@agluck-desktop.sc.intel.com>
In-Reply-To: <4f7b27487632dad07@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/12 12:37, Luck, Tony: <tony.luck@intel.com wrote:
> ACPI code is shared by arch/x86 and arch/ia64. ia64 doesn't provide a plain
> "halt()" function.  Use safe_halt() instead.
>
> Signed-off-by: Tony Luck<tony.luck@intel.com>
>
> ---
>
> E-mail discussion indicated this would be OK. Please check on x86
> before applying.

Tested-by: Boris Ostrovsky <boris.ostrovsky@amd.com>

-boris

>
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index b3447f6..f3decb3 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -786,7 +786,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
>   	while (1) {
>
>   		if (cx->entry_method == ACPI_CSTATE_HALT)
> -			halt();
> +			safe_halt();
>   		else if (cx->entry_method == ACPI_CSTATE_SYSTEMIO) {
>   			inb(cx->address);
>   			/* See comment in acpi_idle_do_entry() */
>


