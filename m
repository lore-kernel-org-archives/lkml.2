Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0GGAyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:54:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24197 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0GGAx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:53:59 -0400
Message-ID: <4C33CF1C.7020803@kernel.org>
Date: Tue, 06 Jul 2010 17:49:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       clemens@ladisch.de
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
 	resources
References: <20100630211516.GA25991@us.ibm.com>	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>	<20100630235949.GA5120@us.ibm.com>	<20100702143515.2896d728@virtuousgeek.org>	<4C33B883.6010206@kernel.org> <AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
In-Reply-To: <AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0201.4C33CFE9.0031,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 04:58 PM, Linus Torvalds wrote:
> On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> So you want to use pci=override_bios to reallocate all bios assigned resource include
>> peer root buses resources and pci bridge resource and pci devices BAR?
> 
> In a perfect world, we'd never need this at all, but sicne that's not
> an option, the second-best alternative might be something like the
> following:
> 
>   pci=override=off # default
>   pci=override=conflict # override only on conflicts
>   pci=override=<device> # clear BIOS allocations for <device> (and any
> children, if it's a bus)

current:
if there is conflict, like pci bridge resources or pci devices resources is not in the scope of peer root bus resource range.
or pci devices is not in pci bridge resources range.
kernel would reject the resource and try to get new range in parent resource for the children.

so current default is overriding the conflicts already.

Maybe your conflicts have other meaning? like pci bridge resource size is not big enough?

or we can have use

pci=override=small_bridge

or 

pci=override=bridges

instead?

Thanks

Yinghai
