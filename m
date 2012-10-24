Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2JXBgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:36:21 -0400
Received: from bosmailout16.eigbox.net ([66.96.186.16]:35187 "EHLO
	bosmailout16.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2JXBgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:36:20 -0400
X-Greylist: delayed 2478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 21:36:20 EDT
X-Authority-Analysis: v=2.0 cv=Jc0LWz2V c=1 sm=1
 a=+z5hrXJ4/nZDuNu/IEWDVw==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=nlncmwdmcoAA:10 a=8nJEP1OIZ-IA:10 a=cRAXhCL3cXIA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=OLL_FvSJAAAA:8 a=YgUFFZ79AAAA:8
 a=P-2dg1YcEPkYP63RdZ8A:9 a=wPNLvfGTeEIA:10 a=fD39coGZ-YEA:10
 a=BF10AaGwQl41phDg7WSPyA==:117
X-EN-OrigOutIP: 10.20.18.8
X-EN-IMPSID: Eouz1k0070ASroS01ouzLE
Message-ID: <50873BFF.4070508@yahoo.es>
Date: Wed, 24 Oct 2012 08:53:19 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness configurable
References: <507A6FA5.1000800@yahoo.es> <20121023161218.45a7ae4e.akpm@linux-foundation.org>
In-Reply-To: <20121023161218.45a7ae4e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.33
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 10/24/2012 7:12 AM, Andrew Morton wrote:
> On Sun, 14 Oct 2012 15:54:13 +0800
> Hein Tibosch <hein_tibosch@yahoo.es> wrote:
>
>> The dw_dmac was originally developed for avr32 to be used with the Synopsys
>> DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
>> memory was done with the little-endian readl/writel functions(1)
>>
>> This broke the driver for the avr32 platform, because it needs big (native)
>> endian accessors.
>> This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
>> which will default be true for AVR32
> Do we think this bug should be fixed in earlier kernel versions?
>
> If so, the patch might need to be tweaked for 3.6 and earlier, which
> don't have the dma_read_byaddr() definition.

The 'bug' only affected avr32 (AP700x) users. I think there won't be much demand
for it. Beside that, there were more breakages after 2.6.38, which have only
recently been fixed in 3.7-rc1

These patches should then be back-ported as well:

 http://www.spinics.net/lists/linux-mmc/msg16104.html
 http://www.gossamer-threads.com/lists/linux/kernel/1603537

Thanks, Hein
