Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0IHTJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:09:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36104 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab0IHTJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:09:46 -0400
Message-ID: <4C87DF5C.70801@zytor.com>
Date: Wed, 08 Sep 2010 12:09:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
References: <20100901213318.19353.54619.stgit@localhost.localdomain>	 <41621.148.87.67.139.1283378664.squirrel@www.xenotime.net> <1283379098.28591.20.camel@pjaxe>
In-Reply-To: <1283379098.28591.20.camel@pjaxe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 03:11 PM, Peter P Waskiewicz Jr wrote:
> On Wed, 2010-09-01 at 15:04 -0700, rdunlap@xenotime.net wrote:
>> On Wed, September 1, 2010 2:33 pm, Peter P Waskiewicz Jr wrote:
>>> Documentation/x86/x86_64/boot-options.txt |    4 ++++
>>> arch/x86/mm/srat_64.c                     |   20 +++++++++++++++++--- 2
>>> files changed, 21 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c index
>>> f9897f7..8719472 100644 --- a/arch/x86/mm/srat_64.c
>>> +++ b/arch/x86/mm/srat_64.c
>>> @@ -351,6 +351,15 @@ int __init acpi_get_nodes(struct bootnode *physnodes)
>>>  return ret; }
>>>
>>>
>>> +int srat_bypass_bios = 0;
>>
>> static int srat_bypass_bios;
>>
>> Don't need to init to 0.
> 
> I'll fix and send a second version.  Thanks Randy.
> 

Should be static *bool* srat_bypass_bios;

Please use bool for actual booleans; it prevents someone from being
"smart" and using values like 2 or -1 for "special cases".

	-hpa
