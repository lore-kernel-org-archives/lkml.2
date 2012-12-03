Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2LCR0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:26:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36945 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2LCR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:26:30 -0500
Message-ID: <50BCE0C0.8000708@wwwdotorg.org>
Date: Mon, 03 Dec 2012 10:26:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V7 2/7] ARM: dt: change .dtb build rules to build in dts
 directory
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org> <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org> <50BCD030.7020908@gmail.com>
In-Reply-To: <50BCD030.7020908@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 09:15 AM, Rob Herring wrote:
> On 11/27/2012 05:29 PM, Stephen Warren wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> The current rules have the .dtb files build in a different directory
>> from the .dts files. The only reason for this is that it was what
>> PowerPC has done historically. This patch changes ARM to use the generic
>> dtb rule which builds .dtb files in the same directory as the source .dts.
> 
> [snip]
> 
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index a17d5ab..cb217f8 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -136,4 +136,12 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>>  	wm8650-mid.dtb
>>  dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
>>  
>> +targets += dtbs
>>  endif
>> +
>> +dtbs: $(addprefix $(obj)/, $(dtb-y))
>> +	# *.dtb used to be generated in the directory above. Clean out the
>> +	# old build results so people don't accidentally use them.
>> +	rm -f $(obj)/../*.dtb
> 
> Do you intend for this to print out? Seems a little noisy to me for a
> one-time problem. Are you trying to tell users the dtb files moved or
> just prevent them from using the old ones? Quietly removing them would
> still accomplish the latter.

Oh, I just wasn't thinking; I guess this should be @rm or similar. Will
you fix this up locally since you've applied the patches?
