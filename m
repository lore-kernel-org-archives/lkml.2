Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0LGDTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:19:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59502 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0LGDTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jjmjSU9A7msiUWqRsgYEe7kRVGmJxb4Fn74flNjc5vesq2rk/D3oOl7e6aMTt9dAnq
         liRHw2lGgxyIqAfQkYN95UVcnRH7WDU2c5suq4v5x/Li7sjuNZN0273u4Khv9bjkEkVW
         hvroL1tct/whcv8qM5WiJs0u8tALRH2+cF7pU=
Message-ID: <4CFDA7AF.2060201@gmail.com>
Date: Mon, 06 Dec 2010 19:19:11 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sodaville@linutronix.de, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        mmarek@suse.cz
Subject: Re: [PATCH 1/4] of: Add support for linking device tree blobs into
 vmlinux
References: <cover.1291656753.git.dirk.brandewie@gmail.com> <76a37fa459aeadce5d11db8a7cc044687a2e0e8c.1291656753.git.dirk.brandewie@gmail.com> <20101206190251.GB20882@merkur.ravnborg.org>
In-Reply-To: <20101206190251.GB20882@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 11:02 AM, Sam Ravnborg wrote:
> On Mon, Dec 06, 2010 at 09:35:59AM -0800, dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>> -
>> +# DTC
>> +#  ---------------------------------------------------------------------------
>> +
>> +# Generate an assembly file to wrap the output of the device tree compiler
>> +$(obj)/%.dtb.S: $(obj)/%.dtb
>> +	@echo '#include<asm-generic/vmlinux.lds.h>'>  $@
>> +	@echo '.section .dtb.init.rodata,"a"'>>  $@
>> +	@echo '.balign STRUCT_ALIGNMENT'>>  $@
>> +	@echo '.global __dtb_$(*F)_begin'>>  $@
>> +	@echo '__dtb_$(*F)_begin:'>>  $@
>> +	@echo '.incbin "$<" '>>  $@
>> +	@echo '__dtb_$(*F)_end:'>>  $@
>> +	@echo '.global __dtb_$(*F)_end'>>  $@
>> +	@echo '.balign STRUCT_ALIGNMENT'>>  $@
>> +
>
> If we really want this rule in Makefile.lib then at least make it less verbose,
> and more secure.

I started with the change in Makefile.lib because it made sense to me, is there 
a more appropriate place for these rules/commands?

> Something like this:
> quiet_dt_S_dtb_cmd = DTB    $@
>        dt_S_dtb_cmd =                                      \
> (                                                         \
> 	@echo '#include<asm-generic/vmlinux.lds.h>';     \
> 	@echo '.section .dtb.init.rodata,"a"';            \
> 	@echo '.balign STRUCT_ALIGNMENT';                 \
> 	echo '.global __dtb_$(*F)_begin';                 \
> 	echo '__dtb_$(*F)_begin:';                        \
> 	echo '.incbin "$<" ';                             \
> 	echo '__dtb_$(*F)_end:';                          \
> 	echo '.global __dtb_$(*F)_end';                   \
> 	echo '.balign STRUCT_ALIGNMENT';                  \
> )>  $@
>
> $(obj)/%.dtb.S: $(obj)/%.dtb
> 	$(call cmd,dt_S_dtb)
>

I will make the changes in next version.

>
>> +DTC = $(objtree)/scripts/dtc/dtc
>
> If this is the only spot where we use DTC then drop the variable.
>
>> +
>> +quiet_cmd_dtc = DTC $@
>> +      cmd_dtc = $(DTC) -O dtb -o $@ -b 0 $(DTC_FLAGS) $<
>
>
>> +ooo
>
> What is the purpose of these "ooo"? A debugging left-over?
>

Yep sorry

>
> 	Sam

