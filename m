Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2HUOxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:53:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59007 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2HUOxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:53:44 -0400
Message-ID: <5033A0F0.8080705@zytor.com>
Date: Tue, 21 Aug 2012 07:53:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Olof Johansson <olof@lixom.net>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
References: <1345412920-10906-1-git-send-email-olof@lixom.net>  <50320DBD.5080507@canonical.com>  <CAOesGMiUOfg9aNjtsah-n_k-Uqbp4veppxgU=dDUOxBGyB5PxQ@mail.gmail.com> <1345559940.3088.56.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1345559940.3088.56.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 07:39 AM, Matt Fleming wrote:
> On Mon, 2012-08-20 at 14:59 -0700, Olof Johansson wrote:
>>>  From a quick glance with some grepping, efi reboot and efifb will
>>> also no longer work, is that intentional?
>>
>> That's the very point of this patch, the EFI services won't work since
>> there are no runtime services in this state, just boot time setup. If
>> efi_enabled is left on, the reboot will panic.
>
> But efifb should still work without EFI runtime services, no? I see this
> in setup_arch(),
>
> #ifdef CONFIG_VT
> #if defined(CONFIG_VGA_CONSOLE)
>          if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
>                  conswitchp = &vga_con;
> #elif defined(CONFIG_DUMMY_CONSOLE)
>          conswitchp = &dummy_con;
> #endif
> #endif
>
> but efi_enabled check looks bogus now that efi_enabled has come to mean
> "EFI services available?". If we've been passed the dimensions of the
> EFI framebuffer I'm unaware of a reason we can't use it.
>

Yes, this should be conditional on the parameters being available. 
However, efi_mem_type() is probably also ill-defined in this case.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

