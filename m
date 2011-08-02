Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1HBUtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:49:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44841 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1HBUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:49:46 -0400
Message-ID: <4E3862E6.508@lwfinger.net>
Date: Tue, 02 Aug 2011 15:49:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, John W Linville <linville@tuxdriver.com>
CC: geert@linux-m68k.org, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix build errors on sh4 architecture
References: <4e3855e4.8qPfeuR18XtAq7Vs%Larry.Finger@lwfinger.net> <4E385BFA.90406@openwrt.org>
In-Reply-To: <4E385BFA.90406@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 03:20 PM, Felix Fietkau wrote:
> On 2011-08-02 9:54 PM, Larry Finger wrote:
>> When rtlwifi is built for the sh4 architecture, build errors of the following
>> type occur. An explicit reference to<linux/io.h> should fix these. I have not
>> setup the cross-build environment, thus this patch is untested on that platform.
>> It does not cause any problems on i386 or x86_64.
>>
>> v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
>> src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:290: error: implicit
>> declaration of function 'outl': 4 errors in 2 logs
>> v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
>> src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:295: error: implicit
>> declaration of function 'outb': 4 errors in 2 logs
>> v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
>> src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:300: error: implicit
>> declaration of function 'inb': 4 errors in 2 logs
>> v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
>> src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:305: error: implicit
>> declaration of function 'inw': 4 errors in 2 logs
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> Cc: Geert Uytterhoeven<geert@linux-m68k.org>
>> ---
>>
>> John,
>>
>> I'm not sure where this goes. I guess that 3.2 would be OK, unless someone
>> actually tries to build it on sh4. The only time I have seen the errors is
>> in Geert's listing of errors and warnings.
> I looked at the code that uses raw port access, and it looks to me like this is
> just a bunch of x86 specific hacks to mess with the ASPM settings of the PCI
> bridge. This code should probably be either #ifdef'd, removed or rewritten. I
> doubt it'll work properly on other architectures.

Thanks Felix.

John,

I'll take another look at this. Please drop the patch.

Larry
