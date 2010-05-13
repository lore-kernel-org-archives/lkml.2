Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0EMVz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:55:27 -0400
Received: from relay3.sgi.com ([192.48.152.1]:35381 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932357Ab0EMVzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:55:23 -0400
Message-ID: <4BEC7544.1080506@sgi.com>
Date: Thu, 13 May 2010 14:55:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com> <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com> <4BEC73B2.2020909@oracle.com>
In-Reply-To: <4BEC73B2.2020909@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



...
> in setup.c::setup_arch()
> 
>         setup_memory_map();
>         parse_setup_data();
>         /* update the e820_saved too */
>         e820_reserve_setup_data();
> 	...
> 	parse_early_param();
> 	...
> 	finish_e820_parsing();
> 
> 
> 
> efi memmap is appended to e820 by parse_setup_data
> e820_reserve_setup_data() will copy e820 to e820_saved.
> 
> 
> or do you have old boot loader 
> 
>         if (boot_params.hdr.version < 0x0209)
>                 return;
> 
> YH

I saw that too, and wondered why e820_saved did not
have the extra entries.   The comment indicates it
should.

I'm on the system tonight and will investigate this
further.

Thanks!
Mike
