Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0EMWsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:48:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0EMWsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:48:12 -0400
Message-ID: <4BEC8161.6050206@zytor.com>
Date: Thu, 13 May 2010 15:46:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Yinghai <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com> <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com> <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com>
In-Reply-To: <4BEC7544.1080506@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 02:55 PM, Mike Travis wrote:
> 
> I saw that too, and wondered why e820_saved did not
> have the extra entries.   The comment indicates it
> should.
> 
> I'm on the system tonight and will investigate this
> further.
> 

e820_saved lacks the extra entries because they aren't being passed in
from the bootloader, as they should, and instead you're using
add_efi_memmap which is, as far as the kernel is concerned, a post-boot
modification.

That being said, add_efi_memmap does come from the firmware, and as such
it would be legitimate for it to add them to e820_saved.

	-hpa
