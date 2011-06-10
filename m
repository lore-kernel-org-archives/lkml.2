Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab1FJX0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:26:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab1FJX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:26:34 -0400
Message-ID: <4DF2A81C.7000902@kernel.org>
Date: Fri, 10 Jun 2011 16:26:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <4DF2A17E.7000103@kernel.org> <20110610230359.GA2084@srcf.ucam.org>
In-Reply-To: <20110610230359.GA2084@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DF2A823.0047,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 04:03 PM, Matthew Garrett wrote:
> On Fri, Jun 10, 2011 at 03:58:06PM -0700, Yinghai Lu wrote:
> 
>> the problem is : overlapping between kernel code with boot services code.
> 
> SHouldn't checking against the iomem resource map avoid that?
> 
>> now e820 table that is passed from bootloader do not include boot services code range. and also current boot/head_64.S will not
>> try to find usable range for decompressed kernel ( too early )...
>>
>> So solution will be:
>> 1. revert Matthew Garrett's patch, because it breaking unknown good platform.
> 
> That's acceptable if we can't find a better solution.

good.

> 
>> 2. ask vendor of system that Matthew try to fix to go back fix their firmware. otherwise user have stay with CSM with it.
> 
> This isn't an option.
> 
> The medium-term fix is to ensure that the bootloaders don't put the 
> kernel on top of boot services code. 

that is not enough, will need to make arch/x86/boot/compressed/head_64.S parse e820 table to find right decompress position.

> The long-term fix is to perform the 
> SetVirtualAddressMap transition in either the bootloader or the kernel 
> entry point.

that is sane and clean workaround for those systems with buggy fw.

> But the short-term fix here is to allocate all boot 
> services regions that don't overlap with the kernel. That'll fix some 
> number of machines and shouldn't break any existing ones.

that is questionable and dangerous. before SetVirtualAddressMap, some function in boot service could be called,
those data or code for boot services could be overlapped kernel. so kernel code could be damaged by those calling.

also that will make our kernel code more messy.

Yinghai
