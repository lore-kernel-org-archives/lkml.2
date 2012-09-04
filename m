Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2IDUYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:24:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48772 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677Ab2IDUYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:24:36 -0400
Message-ID: <50466363.9010900@zytor.com>
Date: Tue, 04 Sep 2012 13:24:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix ACPI BGRT support for images located in EFI boot
 services memory
References: <cover.1346361959.git.josh@joshtriplett.org> <1346768840.4244.52.camel@mfleming-mobl1.ger.corp.intel.com> <20120904175952.GA4103@jtriplet-mobl1> <5046442E.7020207@zytor.com> <20120904194523.GA5064@jtriplet-mobl1>
In-Reply-To: <20120904194523.GA5064@jtriplet-mobl1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 12:45 PM, Josh Triplett wrote:
>>
>> There are some platforms which have bugs in this area, so there are
>> other reasons to defer freeing up boot memory until as late in the
>> boot process as we can possibly get away with.
>>
>> free_initmem() is presuambly the place that makes most sense.
>
> You're suggesting a call from free_initmem() to
> efi_free_boot_services()?  Or, from init_post() right before the call to
> free_initmem()?
>

free_initmem() is arch-specific, so probably the latter.

>> This
>> is EFI-specific but not x86-specific, let's not commingle those
>> concepts, please...
>
> init/main.c already calls the x86-specific efi_enter_virtual_mode
> (defined in arch/x86/platform/efi/efi.c), and I split the call to the
> x86-specific efi_free_boot_services out of that.  Neither of those
> functions exists on non-x86 platforms, and thus I mirrored the #ifdef
> currently wrapped around efi_enter_virtual_mode for the new call to
> efi_free_boot_services.  While it might make sense for that code to
> exist on non-x86 EFI platforms, it currently doesn't.  At best, I could
> add static inline stubs to linux/efi.h for those functions to avoid the
> ifdefs, but as far as I can tell the same issue applies to quite a few
> more functions in efi.h.
>
> Would you like me to add the static inline stubs for the couple of
> functions called from init/main.c, or leave the #ifdefs?
>

I think that would really help clean things up.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

