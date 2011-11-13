Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1KMOHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 09:07:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab1KMOHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 09:07:42 -0500
Message-ID: <4EBFCF13.9090605@redhat.com>
Date: Sun, 13 Nov 2011 16:07:15 +0200
From: Ronen Hod <rhod@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
References: <87wrbkvh3v.fsf@rustcorp.com.au> <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy> <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au> <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com> <1320828366.31056.16.camel@lappy> <4EBA744D.8020107@redhat.com> <1320842938.31056.55.camel@lappy> <20111109151954.GA25329@redhat.com>
In-Reply-To: <20111109151954.GA25329@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 05:19 PM, Michael S. Tsirkin wrote:
> On Wed, Nov 09, 2011 at 02:48:58PM +0200, Sasha Levin wrote:
>> On Wed, 2011-11-09 at 14:38 +0200, Avi Kivity wrote:
>>> On 11/09/2011 10:46 AM, Sasha Levin wrote:
>>>>> Alternatively we can add new structures with new
>>>>> structure IDs, pointed to from PCI configuration space.
>>>>>
>>>>> As we don't yet have devices or drivers with 64 bit features,
>>>>> I decided we don't need high feature bits in legacy space.
>>>>> This also frees up feature bit 31 as we don't need it
>>>>> to enable high feature bits anymore.
>>>> KVM tool actually has support for 64bit features, we can probably remove
>>>> that when Pekka isn't looking :)
>>>>
>>> What about the Windows drivers?
>> While 64-bit features were defined, there was no actual devices to use
>> them.
>>
>> So even if Windows drivers had the ability to support 64-bit features,
>> no device ever needed it therefore no device ever activated it.
>>
>> A potential issue might arise when we remap feature bit 31 to do
>> something else, and when activated it would fool Windows drivers to
>> think that 64-bit features are now activated, while they're not - but
>> thats not something that should happen since legacy layout shouldn't
>> have that field enabled as per the spec (no new features in legacy
>> code).
>>
>> I was unable to check if it was actually implemented in the drivers
>> because
>> http://git.kernel.org/?p=virt/kvm/kvm-guest-drivers-windows.git;a=summary is not quite there (*cough*).

https://github.com/YanVugenfirer/kvm-guest-drivers-windows

> I'm pretty sure windows drivers didn't yet get to it.
> This was out for a very short time.
>
>> -- 
>>
>> Sasha.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

