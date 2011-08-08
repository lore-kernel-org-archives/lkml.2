Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1HHU4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:56:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57303 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1HHU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:56:52 -0400
Message-ID: <4E404D68.5060507@zytor.com>
Date: Mon, 08 Aug 2011 15:56:08 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC][PATCH 2/2] x86, cpu, amd: Add a per-vendor BSP function
References: <1312829872-20260-1-git-send-email-bp@amd64.org> <1312829872-20260-3-git-send-email-bp@amd64.org>
In-Reply-To: <1312829872-20260-3-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 01:57 PM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a per-vendor function which runs everything that needs to run once
> on the BSP during boot. Concentrate AMD-specific functionality there.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>  
> +static void __init vendor_run_on_bsp(struct cpuinfo_x86 *c)
> +{
> +	switch (c->x86_vendor) {
> +	case X86_VENDOR_AMD:
> +		amd_run_on_bsp(c);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +}
> +

This is totally going backwards.  We *should* be using struct cpu_dev
rather than switch statements for this.

	-hpa

