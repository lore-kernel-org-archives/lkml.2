Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1FNSHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:07:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:64536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1FNSHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,365,1304319600"; 
   d="scan'208";a="16162134"
Message-ID: <4DF7A343.2000808@linux.intel.com>
Date: Tue, 14 Jun 2011 11:06:59 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <4DF2A17E.7000103@kernel.org> <20110610230359.GA2084@srcf.ucam.org> <4DF2A81C.7000902@kernel.org> <4DF2A984.6060705@linux.intel.com> <4DF2AEEF.6040208@kernel.org> <4DF2B02F.30802@linux.intel.com> <4DF2B492.8050408@kernel.org>
In-Reply-To: <4DF2B492.8050408@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 05:19 PM, Yinghai Lu wrote:
> On 06/10/2011 05:00 PM, H. Peter Anvin wrote:
>> On 06/10/2011 04:55 PM, Yinghai Lu wrote:
>>>>
>>>> No, it should be, because the boot loader can control the decompress
>>>> position to avoid the problems.
>>>
>>> bootloader could find out decompressed kernel size?
>>>
>>
>> Yes, it's the init_size field in the header.
> 
> good, with relocatable_kernel, kernel_alignment, and init_size in header, bootloader could find right position for kernel.
> 

Yes, and that's the very reason for it... which unfortunately means
kernel address randomization is hard(er) because it means the kernel
wants to second-guess the boot loader again.

	-hpa
