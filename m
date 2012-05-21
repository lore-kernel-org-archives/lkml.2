Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2EUXMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:12:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47823 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2EUXMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:12:35 -0400
Message-ID: <4FBACBD5.6080207@zytor.com>
Date: Mon, 21 May 2012 16:12:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521230623.GO17031@redhat.com>
In-Reply-To: <20120521230623.GO17031@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 04:06 PM, Michael S. Tsirkin wrote:
> 
> I think the reason is __apic_read which now simply copies the registers
> out to guest, this code will become less straight-forward if it's not
> 1:1.
> 

It can still be 1:1, just drop the 12 bytes of completely useless
padding after each 32-bit datum.

>> And if you look deeper, then you'll notice that _ALL_ APIC registers
>> are on a 16 byte boundary (thanks Peter for pointing that out).
>>
>> So it's even more silly to have a 1:1 representation instead of
>> implementing the default emulated apic_read/write functions to access
>> (offset >> 2).
>>
>> And of course, that design decision causes lookups to be slow.
> 
> Yes, it might be one of the reasons why my patch helps so
> much: it adds a cache in front of this data structure.
> 

Well, *fix the fscking data structure first*.

> 
> So what you propose is in fact to rework apic registers at least for
> ISR,IRR,TMR to use a bitmap.
> I am fine with this suggestion but would like some feedback from kvm
> maintainers on where they want to go before I spend time on that.
> 

This should be a 20-minute hack.

	-hpa
