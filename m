Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0GGA6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:58:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:13164 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0GGA6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:58:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,549,1272870000"; 
   d="scan'208";a="297267014"
Message-ID: <4C33D123.4080209@intel.com>
Date: Tue, 06 Jul 2010 17:58:11 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>	<4C2A8879.8010000@intel.com>	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>	<4C2AC55E.3040303@intel.com>	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>	<1277923422.16256.8.camel@localhost>	<4C2B9DAC.1030806@intel.com>	<1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com>	<1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>	<1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>	<1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>	<1278324973.16975.68.camel@localhost>	<AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>	<1278463901.20082.34.camel@dwillia2-linux> <AANLkTilnrdghkK1y7vc2Zi0C7KMXHYXpI_whecRxTD_8@mail.gmail.com>
In-Reply-To: <AANLkTilnrdghkK1y7vc2Zi0C7KMXHYXpI_whecRxTD_8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/2010 5:51 PM, Chris Li wrote:
> On Tue, Jul 6, 2010 at 5:51 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>> No, it should be PCI_DEVICE_ID_INTEL_IOAT_SNB (0x402f) for the dma
>> engine at 00:0f.0 .  PCI_DEVICE_ID_INTEL_ESB2_0 is the LPC controller at
>> 00:1f.0,
>>
>>> That seems to be the reason preventing the warning to be print out. I am not
>>> sure the warning should be always print out. Just curious why it did
>>> not trigger.
>>
>> It should always trigger, and I have verified as much with the attached
>> replacement patch (by forcing the error on a working system), but we run
>> into a new problem.  dma_pool_alloc() assumes that any dma_mapping error
>> is transient.  Do we need a new type of dma_mapping_error() that
>> indicates permanent failure versus ENOMEM?  The driver can handle the
>> allocation failure, but it never gets the chance.
>
> Should I test your V2 patch instead?
>

It would confirm that we are catching the BIOS misconfiguration, but 
your system will get stuck in this loop.  So just make sure you can get 
back to a working config, which it sounds like you can.

--
Dan



