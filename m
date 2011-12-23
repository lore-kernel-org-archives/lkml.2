Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1LWQWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:22:24 -0500
Received: from 9.mo4.mail-out.ovh.net ([46.105.40.176]:45056 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754072Ab1LWQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:22:20 -0500
Message-ID: <4EF4A696.9010509@eukrea.com>
Date: Fri, 23 Dec 2011 17:04:38 +0100
From: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>,
        open list <linux-kernel@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v2 08/19] dma: MX3_IPU fix depends
References: <CAOMZO5AOpFtkJDmTSjPmvPVr0ra4d7jUcihGgncYE2VtfKCeSQ@mail.gmail.com>  <1323785575-22703-1-git-send-email-eric@eukrea.com> <1324655127.1633.4.camel@vkoul-udesk3>
In-Reply-To: <1324655127.1633.4.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12004626283301023123
X-Ovh-Remote: 92.90.17.8 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefkedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefjeenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefjeenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucffohhmrghinhepne
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/12/2011 16:45, Vinod Koul a écrit :
> On Tue, 2011-12-13 at 15:12 +0100, Eric Bénard wrote:
>> ARCH_MX3 was removed in commit a89cf59 :
>> "arm/imx: merge i.MX3 and i.MX6"
>> thus preventing to select MX3_IPU, thus preventing IPU and display
>> to work on i.MX3x SOC.
>> i.MX SDMA support is also affected.
>>
>> Signed-off-by: Eric Bénard<eric@eukrea.com>
>> Cc: Sascha Hauer<kernel@pengutronix.de>
>> Cc: Vinod Koul<vinod.koul@intel.com>
>> Cc: Dan Williams<dan.j.williams@intel.com>
>> ---
>> v2: improve comment based on Sergei's comments, and also handle SDMA
>> case based on Fabio's comment
>>   drivers/dma/Kconfig |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index ab8f469..5a99bb3 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -124,7 +124,7 @@ config MV_XOR
>>
>>   config MX3_IPU
>>   	bool "MX3x Image Processing Unit support"
>> -	depends on ARCH_MX3
>> +	depends on SOC_IMX31 || SOC_IMX35
>>   	select DMA_ENGINE
>>   	default y
>>   	help
>> @@ -216,7 +216,7 @@ config PCH_DMA
>>
>>   config IMX_SDMA
>>   	tristate "i.MX SDMA support"
>> -	depends on ARCH_MX25 || ARCH_MX3 || ARCH_MX5
>> +	depends on ARCH_MX25 || SOC_IMX31 || SOC_IMX35 || ARCH_MX5
>>   	select DMA_ENGINE
>>   	help
>>   	  Support the i.MX SDMA engine. This engine is integrated into
> Which tree is this targeted to?
>
if I followed everything (see Stephen Rothwell mail titled "linux-next: manual 
merge of the slave-dma tree with the arm-soc tree"), this patch was not 
applieed because the problem was already fixed in commit 8e2d41f8c856 ("dma 
i.MX: remove individual SOC dependency") from the slave-dma tree

Eric
