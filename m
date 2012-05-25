Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2EYLUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:20:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:42668 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab2EYLUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:20:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147739037"
Date: Fri, 25 May 2012 14:20:15 +0300 (EEST)
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
X-X-Sender: jsakkine@jsakkine-mobl1.tm.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Subject: Re: [PATCH] x86, realmode: 16-bit real-mode code support for relocs
 tool
In-Reply-To: <20120525060542.GA28472@kroah.com>
Message-ID: <alpine.DEB.2.02.1205251419040.2472@jsakkine-mobl1.tm.intel.com>
References: <1337924683-16189-1-git-send-email-jarkko.sakkinen@intel.com> <20120525060542.GA28472@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
Organization: Intel Finland Oy - BIC 0357606-4 - PL 28100181 Helsinki
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2012, Greg KH wrote:

> On Fri, May 25, 2012 at 08:44:43AM +0300, Jarkko Sakkinen wrote:
>> From: "H. Peter Anvin" <hpa@linux.intel.com>
>>
>> A new option is added to the relocs tool called '--realmode'.
>> This option causes the generation of 16-bit segment relocations
>> and 32-bit linear relocations for the real-mode code. When
>> the real-mode code is moved to the low-memory during kernel
>> initialization, these relocation entries can be used to
>> relocate the code properly.
>>
>> In the assembly code 16-bit segment relocations must be relative
>> to the 'real_mode_seg' absolute symbol. Linear relocations must be
>> relative to a symbol prefixed with 'pa_'.
>>
>> 16-bit segment relocation is used to load cs:ip in 16-bit code.
>> Linear relocations are used in the 32-bit code for relocatable
>> data references. They are declared in the linker script of the
>> real-mode code.
>>
>> The relocs tool is moved to arch/x86/tools/relocs.c, and added new
>> target archscripts that can be used to build scripts needed building
>> an architecture.  be compiled before building the arch/x86 tree.
>>
>> [ hpa: accelerating this because it detects invalid absolute
>>   relocations, a serious bug in binutils 2.22.52.0.x which currently
>>   produces bad kernels. ]
>>
>> [ jsakkine: pulled tools/include/tools/le_byteshift.h in order
>>   to make this patch compile in 3.3 ]
>
> Nope, your patch still doesn't apply, are you sure you sent me the
> updated one?  It fails with:
>
> patching file arch/x86/boot/compressed/Makefile
> Hunk #1 succeeded at 40 (offset 1 line).
> patching file arch/x86/boot/compressed/relocs.c
> Hunk #1 FAILED at 1.
> File arch/x86/boot/compressed/relocs.c is not empty after patch, as expected
> 1 out of 1 hunk FAILED -- rejects in file arch/x86/boot/compressed/relocs.c
>
> when applying it to the 3.3-stable queue.
>
> What did you generate it against?

Sent a new patch that is against 3.3.7.

>
> thanks,
>
> greg k-h
>

/Jarkko
