Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1KGUgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:36:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45190 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab1KGUgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:36:40 -0500
Message-ID: <4EB8413D.6030500@zytor.com>
Date: Mon, 07 Nov 2011 12:36:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org> <20111107202324.GA27515@srcf.ucam.org>
In-Reply-To: <20111107202324.GA27515@srcf.ucam.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 12:23 PM, Matthew Garrett wrote:
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
> 

Yes, I think it makes a lot of sense.  If we need to introduce new
meta-types to deal with the fact that there are EFI types that don't map
to E820, then so be it... and this is *exactly* why we want the EFI
setup stub to be part of the kernel image and not off in a separate
bootloader, requiring a stable interface...

	-hpa
