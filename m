Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2GWRsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:48:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57713 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab2GWRsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:48:16 -0400
Message-ID: <500D8E5C.9020206@wwwdotorg.org>
Date: Mon, 23 Jul 2012 11:48:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-9-git-send-email-catalin.marinas@arm.com> <4FF75986.8010706@wwwdotorg.org> <20120708091819.GA3845@arm.com>
In-Reply-To: <20120708091819.GA3845@arm.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 03:18 AM, Catalin Marinas wrote:
> On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
>> On 07/06/2012 03:05 PM, Catalin Marinas wrote:
>>> The patch adds the kernel booting and the initial setup code.
>>> Documentation/aarch64/booting.txt describes the booting protocol on the
>>> AArch64 Linux kernel. This is subject to change following the work on
>>> boot standardisation, ACPI.
...
>>> +4. Call the kernel image
>>> +------------------------
>>> +
>>> +Requirement: MANDATORY
>>> +
>>> +The decompressed kernel image contains a 32-byte header as follows:
>>> +
>>> +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
>>> +  u32 res0	= 0;		/* reserved */
>>> +  u64 text_offset;		/* Image load offset */
>>> +  u64 res1	= 0;		/* reserved */
>>> +  u64 res2	= 0;		/* reserved */
>>> +
>>> +The image must be placed at the specified offset (currently 0x80000)
>>> +from the start of the system RAM (aligned to 2MB) and called there.
>>
>> Is "0x80000" meant to have an extra "0"; 0x80000 isn't aligned to 2MB
>> unless I'm really missing too much sleep today.
>  
> The value is correct, it wasn't meant to be aligned to 2MB. Why would
> that be? It's just an offset from the start of the RAM, which must
> indeed be 2MB aligned (PHYS_OFFSET).

Oh, I see, it's the start of SDRAM that's aligned to 2MB, not the offset
from the start of SDRAM that needs to be aligned to 2MB. The wording
seems slightly unclear to me. Perhaps just drop the mention of alignment
at all, or add "which is" before "aligned to 2MB"?
