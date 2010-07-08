Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab0GHN1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:27:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33093 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab0GHN06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HLsBcfVWE9Z7xQekHqMWJx/U+cyCGd0NPmoCcAcNBqG2Pxu9HF99q/4fl3awwggRPN
         Vwr2MsbEm9OvfAzkXDfCwKPLp6er4Ol6UpUTPG4qyAbS/fTk5fkv2rwgOchsNsVvjyVI
         WB6FrHH3RcUu6ix3oM/BYbRQQH6dbaswN+RXY=
MIME-Version: 1.0
In-Reply-To: <1278528930.2852.12.camel@sbs-t61.sc.intel.com>
References: <20100630211516.GA25991@us.ibm.com>
	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
	<20100630235949.GA5120@us.ibm.com>
	<20100702143515.2896d728@virtuousgeek.org>
	<4C33B883.6010206@kernel.org>
	<AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
	<4C33CF1C.7020803@kernel.org>
	<AANLkTiksRIyTSBWPThUqhG-5-JXpZLlJ87fyxrXuXpbO@mail.gmail.com>
	<20100707113523.09c2d0e4@virtuousgeek.org>
	<1278528930.2852.12.camel@sbs-t61.sc.intel.com>
Date: Thu, 8 Jul 2010 23:26:56 +1000
Message-ID: <AANLkTil6Div5IUJQh1bBeeR9un7b_plsIQqrVWccKAH8@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port 
	resources
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ram Pai <linuxram@us.ibm.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "clemens@ladisch.de" <clemens@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, that patch fixes the invalid memtype messages on boot and the
graphics performance.

On Thu, Jul 8, 2010 at 4:55 AM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> Andrew, Can you check if this patch resolves your PAT issue?
>
> http://marc.info/?l=linux-kernel&m=127833440902862&w=2
>
> thanks,
> suresh
>
> On Wed, 2010-07-07 at 11:35 -0700, Jesse Barnes wrote:
>> This looks like a different issue, I think the PAT code tracks memtypes
>> like this.
>>
>> Suresh, any changes in this area that might explain this?
>>
>> Jesse
>>
>> On Wed, 7 Jul 2010 14:28:47 +1000
>> Andrew Hendry <andrew.hendry@gmail.com> wrote:
>>
>> > Is this the same or related issue?
>> >
>> > http://lkml.org/lkml/2010/7/6/108
>> > New messages since -rc4, X and graphics really slow after.
>> >
>> > [    1.387013] swapper:1 freeing invalid memtype bf788000-bf789000
>> > [    1.387409] swapper:1 freeing invalid memtype bf789000-bf78a000
>> > [    5.999675] modprobe:548 freeing invalid memtype d0000000-d0040000
>> > [    6.068347] modprobe:548 freeing invalid memtype d0140000-d0150000
>> > [    6.068647] modprobe:548 freeing invalid memtype d0150000-d0160000
>> > [    6.069661] modprobe:548 freeing invalid memtype d0170000-d01f0000
>> > [    6.085969] modprobe:548 freeing invalid memtype d01f0000-d0200000
>> > [    6.087673] modprobe:548 freeing invalid memtype d0210000-d0220000
>> > [    6.087900] modprobe:548 freeing invalid memtype d0220000-d0230000
>> > [    6.088092] modprobe:548 freeing invalid memtype d0230000-d0240000
>> > [    6.088317] modprobe:548 freeing invalid memtype d0240000-d0250000
>> >
>> >
>> > On Wed, Jul 7, 2010 at 10:49 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > > On 07/06/2010 04:58 PM, Linus Torvalds wrote:
>> > >> On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > >>>
>> > >>> So you want to use pci=override_bios to reallocate all bios assigned resource include
>> > >>> peer root buses resources and pci bridge resource and pci devices BAR?
>> > >>
>> > >> In a perfect world, we'd never need this at all, but sicne that's not
>> > >> an option, the second-best alternative might be something like the
>> > >> following:
>> > >>
>> > >>   pci=override=off # default
>> > >>   pci=override=conflict # override only on conflicts
>> > >>   pci=override=<device> # clear BIOS allocations for <device> (and any
>> > >> children, if it's a bus)
>> > >
>> > > current:
>> > > if there is conflict, like pci bridge resources or pci devices resources is not in the scope of peer root bus resource range.
>> > > or pci devices is not in pci bridge resources range.
>> > > kernel would reject the resource and try to get new range in parent resource for the children.
>> > >
>> > > so current default is overriding the conflicts already.
>> > >
>> > > Maybe your conflicts have other meaning? like pci bridge resource size is not big enough?
>> > >
>> > > or we can have use
>> > >
>> > > pci=override=small_bridge
>> > >
>> > > or
>> > >
>> > > pci=override=bridges
>> > >
>> > > instead?
>> > >
>> > > Thanks
>> > >
>> > > Yinghai
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > > Please read the FAQ at  http://www.tux.org/lkml/
>> > >
>> >
>>
>>
>
>
