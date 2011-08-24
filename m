Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1HXVDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:03:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1HXVDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:03:35 -0400
Message-ID: <4E55670F.90102@zytor.com>
Date: Wed, 24 Aug 2011 14:03:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: base support for the TS-5500 platform
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 01:23 PM, Vivien Didelot wrote:
> +
> +/**
> + * ts5500_pre_detect() - check for TS-5500 specific features
> + *
> + * It is not safe to read ID register if we are not sure that it's a TS SBC.
> + * Since TS SBCs don't have DMI support, it is safer to check for a TS-5500
> + * specific feature such as the processor.
> + */
> +static int ts5500_pre_detect(void)
> +{
> +	/* Check for AMD ElanSC520 Microcontroller */
> +	if (!(cpu_info.x86_vendor == X86_VENDOR_AMD &&
> +	      cpu_info.x86 == AMD_ELAN_FAMILY &&
> +	      cpu_info.x86_model == AMD_ELAN_SC520))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +

Doesn't this mean you will read this unsafe register on any Elan SC520
platform?  Is that okay?

	-hpa

