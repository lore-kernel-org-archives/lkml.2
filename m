Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2AELWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:22:18 -0500
Received: from mga07.intel.com ([143.182.124.22]:10671 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591Ab2AELWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:22:16 -0500
Subject: Re: [PATCH 1/5] x86: efi: refactor efi_init() a bit
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <1325610682-24811-2-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	 <1325610682-24811-2-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 05 Jan 2012 11:22:02 +0000
Message-ID: <1325762522.3635.23.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
> Break out some of the init steps into helper functions.
> 
> No code changes at all, identical execution flow.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  arch/x86/platform/efi/efi.c |   89 +++++++++++++++++++++++++++----------------
>  1 files changed, 56 insertions(+), 33 deletions(-)

Makes sense. I've got one tiny comment below, but other than that feel
free to add,

Acked-by: Matt Fleming <matt.fleming@intel.com>

>  	if (memmap.desc_size != sizeof(efi_memory_desc_t))
> -		printk(KERN_WARNING
> -		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
> +		printk(KERN_WARNING "Kernel-defined memdesc doesn't match the "
> +		       "one from EFI!\n");

This sort of thing is generally discouraged because splitting a printk
string across more than one line makes it harder to grep for. I'm not
sure this hunk is an improvement.


