Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab2GUPVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 11:21:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58340 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2GUPVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 11:21:45 -0400
Message-ID: <500AC8F6.4010802@zytor.com>
Date: Sat, 21 Jul 2012 08:21:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        initramfs@vger.kernel.org, bigeasy@linutronix.de,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH 1/2] init: Introduce early initrd files through uncompressed
 cpio passing
References: <1342607764-66747-1-git-send-email-trenn@suse.de> <1342607764-66747-2-git-send-email-trenn@suse.de>
In-Reply-To: <1342607764-66747-2-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 03:36 AM, Thomas Renninger wrote:
> cpio parsing code comes from  H. Peter Anvin.
> The CONFIG_EARLY_INITRD feature is architecture independent, but
> for now only enabled/called for X86.
> The problem is that initrd_start must be valid, but there is no
> architecture independent reserve_initrd() call in init/main.c or
> similiar.
> + * Add here new callback functions and the path relevant files show up in an
> + * uncompressed cpio
> + */
> +static __initdata struct initrd_early_data initrd_early_callbacks[] =
> +{
> +	{
> +		.namesp = NULL,
> +	}
> +};
> +

I don't like your callback interface at all.  In fact, it is actively 
broken, because it assumes that all early users are runnable at the same 
time, which is trivially shown false -- the microcode work that Fenghua 
Yu is working on needs access to its early data much, much earlier than 
your ACPI code.

So big NAK on this change.  Instead we should stick to the imperative 
interface that I had in my original code (call the search function with 
a filename and let it return a pointer if found.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

