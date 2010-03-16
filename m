Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937745Ab0CPK7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:59:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52372 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937732Ab0CPK7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:59:21 -0400
Date: Tue, 16 Mar 2010 18:53:35 +0800
From: Arun Bhanu <ab@arunbhanu.com>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       sam@ravnborg.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] microblaze: Fix Makefile to delete build generated
	files
Message-ID: <20100316105335.GA13420@icd1rh0718.eee.ntu.edu.sg>
Reply-To: Arun Bhanu <ab@arunbhanu.com>
Mail-Followup-To: Michal Simek <monstr@monstr.eu>,
	linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
	sam@ravnborg.org, Michal Marek <mmarek@suse.cz>
References: <1268727395-7770-1-git-send-email-arun@bhanu.net> <4B9F4988.20809@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4B9F4988.20809@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Cc: Michal Marek <mmarek@suse.cz> who is the Kbuild maintainer.

* Michal Simek (monstr@monstr.eu) wrote:
> Arun Bhanu wrote:
>> 'make clean' does not to delete the following build generated file:
>> 	arch/microblaze/boot/linux.bin.ub
>>
>> 'make mrproper' does not to delete the following build generated files:
>> 	arch/microblaze/boot/simpleImage.*
>>
>> Fix the Makefile to delete these build generated files.
>>
>> See [1] for a discussion on why simpleImage.* files are deleted with 'make
>> mrproper' and not with 'make clean'.
>> 	[1] http://lkml.org/lkml/2010/3/12/96
>>
>> Signed-off-by: Arun Bhanu <arun@bhanu.net>
>> ---
>>  arch/microblaze/Makefile      |    2 ++
>>  arch/microblaze/boot/Makefile |    2 +-
>>  2 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
>> index d2d6cfc..36926b9 100644
>> --- a/arch/microblaze/Makefile
>> +++ b/arch/microblaze/Makefile
>> @@ -93,3 +93,5 @@ define archhelp
>>    echo '  name of a dts file from the arch/microblaze/boot/dts/ directory'
>>    echo '  (minus the .dts extension).'
>>  endef
>> +
>> +MRPROPER_FILES += $(boot)/simpleImage.*
>
> I personally don't like that this line is in main arch Makefile but I  
> saw that other archs have it too. Will be better to have it only in boot  
> folder but I don't know if is possible to do that.
> Sam: What do you think?

>From my limited understanding of Kbuild, it only includes the top
level Makefile of each architecture. In our case
arch/microblaze/Makefile. If we define MRPROPER_FILES variable in
arch/microblaze/boot/Makefile Kbuild will not evaluate it.

>
>
>> diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
>> index 902cf98..a1fc324 100644
>> --- a/arch/microblaze/boot/Makefile
>> +++ b/arch/microblaze/boot/Makefile
>> @@ -64,4 +64,4 @@ $(obj)/%.dtb: $(dtstree)/%.dts FORCE
>>   clean-kernel += linux.bin linux.bin.gz simpleImage.*
>>  -clean-files += *.dtb simpleImage.*.unstrip
>> +clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
>
> Could you please take a look at clean-kernel option too?
> I think we can simple remove it. It should be any ancient code from powerpc.

Yeah, I think we can safely remove the "clean-kernel" variable as it is
not used by Kbuild infrastructure.

>
> Thanks,
> Michal
>
>
>
>
> -- 
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-Arun
