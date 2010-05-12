Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0ELS4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:56:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab0ELS4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:56:39 -0400
Message-ID: <4BEAF9B6.2040606@zytor.com>
Date: Wed, 12 May 2010 11:55:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com>
In-Reply-To: <4BEAEF10.9040809@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 11:10 AM, Mike Travis wrote:
> 
> Currently, the e820_reserve_resources() function does not add entries
> obtained via the "add_efi_memmap" kernel cmdline option.  This causes
> /sys/firmware/memmap/... to be incomplete (stops after 128 entries).
> Utilities that examine these entries then do not get the complete
> picture of system memory.
> 
> This patch causes the above function to use the e820 memmap instead
> of the e820_saved memmap if "add_efi_memmap" cmdline option is
> specified.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Signed-off-by: Jack Steiner <steiner@sgi.com>

If I'm not mistaken, the very reason for the e820 vs e820_saved map is
that the latter is supposed to reflect the firmware report, whereas the
former is subject to be modified by the kernel.  As this is actually a
reflection of the firmware (although it would be better if you could fix
the bootloader instead of adding hacks in the kernel...) it really
should go into e820_saved as well as e820.  Displaying the adjusted e820
map doesn't seem appropriate under any circumstances.

	-hpa
