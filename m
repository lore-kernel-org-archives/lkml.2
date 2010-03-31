Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab0CaXQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:16:55 -0400
Received: from ozlabs.org ([203.10.76.45]:48813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0CaXQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:16:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: Make e820_remove_range to handle all covered case
Date: Thu, 1 Apr 2010 09:46:47 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <201003301238.43620.rusty@rustcorp.com.au> <4BB18E55.6090903@kernel.org>
In-Reply-To: <4BB18E55.6090903@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004010946.47934.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 04:08:29 pm Yinghai Lu wrote:
> 
> Rusty found on lguest with trim_bios_range, max_pfn is not right anymore, and
> looks e820_remove_range does not work right.
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  LGUEST: 0000000000000000 - 0000000004000000 (usable)
> [    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
> [    0.000000] DMI not present or invalid.
> [    0.000000] last_pfn = 0x3fa0 max_arch_pfn = 0x100000
> [    0.000000] init_memory_mapping: 0000000000000000-0000000003fa0000
> 
> root cause is: the e820_remove_range doesn't handle that all cover case.
> e820_remove_range(BIOS_START, BIOS_END - BIOS_start, ,,)
> get miss one left range.
> 
> Make that is corresponding to e820_update_range() to handle that case too.

Tested-by: Rusty Russell <rusty@rustcorp.com.au>

Please put in -urgent...

Thanks,
Rusty.
