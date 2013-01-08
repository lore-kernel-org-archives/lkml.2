Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3AHUQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:16:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37379 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3AHUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:16:44 -0500
Message-ID: <50EC7E95.1060700@zytor.com>
Date: Tue, 08 Jan 2013 12:16:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com> <20130103174455.GA7350@localhost.localdomain> <50E5C47B.6060707@zytor.com> <20130108194633.GA15194@phenom.dumpdata.com> <50EC77DB.6090300@zytor.com> <20130108200432.GE15194@phenom.dumpdata.com>
In-Reply-To: <20130108200432.GE15194@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 12:04 PM, Konrad Rzeszutek Wilk wrote:
>>
>> Why is this code invoked on Xen at all?  That seems crazy.
> 
>  [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
> 
> has this in x86_64_start_kernel:
> 
> ..
>         load_idt((const struct desc_ptr *)&idt_descr);
> 
> +       /*
> +        * Load microcode early on BSP.
> +        */
> +       load_ucode_bsp(__va(real_mode_data));
> +
>         copy_bootdata(__va(real_mode_data));
> 
> Which gets called after xen_start_kernel has setup pagetables,
> bootparams, etc ready for the generic code to be invoked.
> 
> Or am I looking at an old version of these patches.

We really shouldn't do that in that flow.  This doesn't make sense on
non-native.

	-hpa


