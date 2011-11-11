Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab1KKBCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:02:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60843 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1KKBCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:02:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111107202324.GA27515@srcf.ucam.org>
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org>
	<20111107202324.GA27515@srcf.ucam.org>
Date: Fri, 11 Nov 2011 09:02:41 +0800
Message-ID: <CAC=cRTP5JxuYD2sU+cHi8yso68WTQREOboeQaeOPdqNMYorPkw@mail.gmail.com>
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address is invalid
From: huang ying <huang.ying.caritas@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 4:23 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Nov 07, 2011 at 03:34:48PM +0000, Matt Fleming wrote:
>
>> After the feedback from v1 I tried to unify the efi_ioremap()
>> implementations but ran into the issue detailed in the RH bug report
>> in the changelog. Unless we teach the x86 setup code that
>> EFI_RUNTIME_SERVICES_DATA regions should be part of the direct kernel
>> mapping table (even though they're marked as E820_RESERVED) I think
>> this patch makes the most sense.
>
> Honestly it seems like there may well be an argument for that. We're
> talking about executable code that the kernel will be calling - it seems
> theoretically neater for it to be added to the direct mapping. We're
> just heavily constrained by our collapsing of the EFI memory map onto
> the rather less fine-grained E820 one and the lack of any obvious way to
> extend that in an OS-specific manner. I guess we could expect the
> bootloader to conform to the standard and then re-walk the EFI memory
> map ourselves to fix things up, but eww...

Sorry for late.

Why ioremap_cache() can not work for some EFI_RUNTIME_SERVICES_DATA region?

Best Regards,
Huang Ying
