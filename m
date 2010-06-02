Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab0FBQPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:15:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab0FBQPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:15:12 -0400
Message-ID: <4C068355.9070000@zytor.com>
Date: Wed, 02 Jun 2010 18:14:13 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bill Richardson <wfrichar@chromium.org>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       akpm@linux-foundation.org, fweisbec@gmail.com, yinghai@kernel.org,
       pavel@ucw.cz, shane.wang@intel.com, linux-kernel@vger.kernel.org,
       olofj@chromium.org, msb@chromium.org, drewry@chromium.org
Subject: Re: [RFC] [PATCH] Allow empty e820 map if EFI map will be provided
 later.
References: <20100602151602.GA3656@google.com>
In-Reply-To: <20100602151602.GA3656@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No!  Bloody **** hell no!

This is yet another attempt at doing more of the wrong thing, which not 
only will make it harder to push things that should be earlier in the 
kernel there.

This was settled in 2007 -- it is the boot loaders duty to provide a 
memory map.  The fact that we allowed a hack in to let the kernel itself 
add additional ranges from EFI has proven to be an utter mistake, and 
this is yet another example of it.

Vetoed in the extreme.

	-hpa



On 06/02/2010 05:16 PM, Bill Richardson wrote:
> If you are booting an x86-based system from an EFI BIOS that does not
> provide any e820-style memory maps, setup_arch() calls functions that expect
> to find the e820 maps long before it calls functions to find the EFI maps.
> The default behavior in arch/x86/kernel/e820.c is that if no e820 map
> exists, default_machine_specific_memory_setup() adds two default regions
> just in case. Later, when you get around to using the EFI maps, these
> default regions interfere with the real memory map.
>
> This patch provides a config option that allows the lack of e820 maps to be
> ignored, under the assumption that you know what you're doing and will
> provide a valid EFI memory map to use.
>
> The reason this problem has not arisen before now is that under most
> circumstances either the EFI BIOS' Compatibility Support Module provides an
> e820-style memory map in the first place, or the EFI-aware bootloader
> (grub2, elilo) translates the EFI map to the e280 format before booting the
> kernel.
>
> I'm trying to reduce the boot time and BIOS footprint, so I'm booting
> without either of those pre-boot map translations. This patch allows that to
> happen.
>
> Signed-off-by: Bill Richardson<wfrichar@chromium.org>
