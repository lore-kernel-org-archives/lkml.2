Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2BWDdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:33:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab2BWDdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:33:03 -0500
Message-ID: <4F45B35D.1010702@zytor.com>
Date: Wed, 22 Feb 2012 19:32:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: mingo@redhat.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        keithp@keithp.com, rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        stable@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32
 oops
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org> <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org> <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 06:20 PM, Yinghai Lu wrote:
> 
> Why is MAXMEM used here?
> 
> EFI reserved area could be above 4G?
> 
> if that is the case, you will map all mmio hole below 4g.
> 

OK, dropping this patch for now, at least from -urgent.

We really need to restrict the memory types we map, at least without
ioremap() called on them.  In theory, on x86-64, we could have a
dedicated "1:1" address for each physical address, but there is no good
reason we should ever map memory types other than RAM, ACPI and EFI by
default -- with the possible exception of the low 1 MiB legacy area.

Therefore, I don't see why on Earth we have
kernel_physical_mapping_init() create mappings for areas which are not
RAM.  It has access to the memory map at this point, so there is no
reason for it.  Unfortunately I think we still have a bunch of code
which implicitly assumes the old "PC" model with separate contiguous
memory ranges starting at 0, 1 MiB, and 4 GiB, however, there are more
and more systems where that just doesn't match reality.


	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

