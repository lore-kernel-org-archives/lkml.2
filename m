Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2HMDXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 23:23:07 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:16178 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2HMDXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 23:23:05 -0400
Message-ID: <50287315.5010203@hp.com>
Date: Sun, 12 Aug 2012 21:23:01 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Betty Dall <betty.dall@hp.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor
 ID first
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org> <1344551691.10751.12.camel@ejdallLaptop> <50259FCE.4070205@zytor.com>
In-Reply-To: <50259FCE.4070205@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 05:57 PM, H. Peter Anvin wrote:
> On 08/09/2012 03:34 PM, Betty Dall wrote:
>> I thought this should be a break instead of a continue since the code
>> does a break if the class is 0xffffffff. If the function does not have a
>> valid VENDOR_ID, then the remaining function numbers do not have to be
>> scanned because functions are required to be implemented in order (no
>> skipping a function number.)
>>
> Is that true?  This is certainly not true in PCI in general: there is
> required to be a function 0, but there is no guarantee that functions
> 1-7 don't have gaps.

If that is the case, there is a problem in the original code in
arch/x86/kernel/aperture_64.c.The original code already stops scanning
functions the first time it finds an invalid PCI class:

206                         for (func = 0; func < 8; func++) {
207                                 u32 class, cap;
208                                 u8 type;
209                                 class = read_pci_config(bus, slot, func,
210 PCI_CLASS_REVISION);
211                                 if (class == 0xffffffff)
212                                         break;

-- 
====================================================================
Khalid Aziz
khalid.aziz@hp.com

