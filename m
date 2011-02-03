Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1BCUi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:38:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62458 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BCUi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:38:57 -0500
Message-ID: <4D4B1214.20603@kernel.org>
Date: Thu, 03 Feb 2011 12:37:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - resend] memblock: Don't adjust size in memblock_find_base()
References: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>	<alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>	<4D1BD928.50701@zytor.com>	<alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>	<4D1BE615.4000700@zytor.com>	<20101230090648.GB7306@elte.hu>	<20101230102815.GA29822@elte.hu>	<20101230103002.GA30020@elte.hu>	<AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com>	<AANLkTimpyRXS9dNFATh4GqtA46uynutAvK7Qb5S7WPFO@mail.gmail.com>	<20110105134434.GA22816@elte.hu>	<4D43615B.9060203@kernel.org> <20110203122505.8369330f.akpm@linux-foundation.org>
In-Reply-To: <20110203122505.8369330f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D4B1249.027A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 12:25 PM, Andrew Morton wrote:
> On Fri, 28 Jan 2011 16:37:47 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> While applying patch to use memblock to find aperture for 64bit x86.
>> Ingo found system with 1g + force_iommu
>>
>>> No AGP bridge found
>>> Node 0: aperture @ 38000000 size 32 MB
>>> Aperture pointing to e820 RAM. Ignoring.
>>> Your BIOS doesn't leave a aperture memory hole
>>> Please enable the IOMMU option in the BIOS setup
>>> This costs you 64 MB of RAM
>>> Cannot allocate aperture memory hole (0,65536K)
> 
> I'm trying to work out if we should backport this fix into earlier
> kernels and as is often the case, I wasn't given enough information.
> 
> What are the end-user visible effects of this?  The kernel cannot use
> the AGP bridge?  64MB of RAM wasted?  Something else?

that is needed for further cleanup memblock with x86.

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=refs/heads/x86/bootmem

but it triggers another old bug in core memblock on one Ingo test machine. (with 1g ram but have iommu forced set for debug)
end-user is not supposed to have this conf.

Thanks

Yinghai


