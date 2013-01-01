Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3AARes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 12:34:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42294 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab3AAReq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 12:34:46 -0500
Message-ID: <50E31E18.5010404@zytor.com>
Date: Tue, 01 Jan 2013 09:34:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Stefan Hasko <hasko.stevo@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: boot: compressed: eboot: fix cast warnings
 on 32b platforms
References: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com> <20121226080019.GB11555@liondog.tnic>
In-Reply-To: <20121226080019.GB11555@liondog.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 12:00 AM, Borislav Petkov wrote:
> On Sat, Dec 22, 2012 at 11:23:25AM +0100, Stefan Hasko wrote:
>> Fixed different size cast warnings in function setup_efi_pci
>>
>> Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
> 
> You might want to add the actual compiler warnings to the commit
> message:
> 
> arch/x86/boot/compressed/eboot.c: In function ‘setup_efi_pci’:
> arch/x86/boot/compressed/eboot.c:259:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> arch/x86/boot/compressed/eboot.c:262:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> arch/x86/boot/compressed/eboot.c:348:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> arch/x86/boot/compressed/eboot.c:350:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> And yes, I see them in all{mod,yes}config builds here too. The issue,
> AFAICT, is that setup_data is __u64 to obviously accomodate 8-byte
> pointers on x86-64 but on 32-bit they're half the size. And we obviously
> cannot change struct setup_data since this is an ABI so I'd guess the
> casts to native pointer sizes are ok. So
> 
> Acked-by: Borislav Petkov <bp@alien8.de>
> 

Yes, but stylistically: we don't use uintptr_t in Linux, but rather
"unsigned long".

	-hpa


