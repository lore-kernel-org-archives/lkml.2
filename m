Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0HBCQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:16:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:19724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0HBCQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:16:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,301,1278313200"; 
   d="scan'208";a="306963096"
Date: Mon, 2 Aug 2010 10:35:35 +0800
From: Feng Tang <feng.tang@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <ying.huang@intel.com>
Subject: Re: EFI runtime-services on x86_64
Message-ID: <20100802103535.6442ab49@feng-i7>
In-Reply-To: <201007301458.50263.bjorn.helgaas@hp.com>
References: <201007301458.50263.bjorn.helgaas@hp.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Sat, 31 Jul 2010 04:58:48 +0800
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Hello Feng,
> 
> Can you educate me about your commit 772be899bc, "86: Make EFI RTC
> function depend on 32bit again"?
> 
> It adds "#ifdef CONFIG_X86_32" to avoid using efi_get_time() and
> efi_set_rtc_mmss(), but there's no explanation of *why* those services
> only work on 32-bit.
> 
> Is this an EFI spec limitation?  Do the other EFI runtime services
> work on 64-bit, since you didn't touch them?  Or do we just not use
> any of the others?
> 

Commit 772be899bc, "86: Make EFI RTC function depend on 32bit again" is
a regression fix for 7bd867d "x86: Move get/set_wallclock to x86_platform_ops".
These 2 commits just abstract the rtc service for legacy x86 PC/EFI/Virtualiation
kernel, and has no functional change to existing code.

I'm not familiar with EFI, but my understanding is current EFI code in 
kernel only provides the get/set_time service for x86_32 platform.

Cc Ying who is more familiar with EFI than me.

Thanks,
Feng
