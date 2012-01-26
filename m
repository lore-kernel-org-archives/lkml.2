Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2AZACr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 19:02:47 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28867 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2AZACp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:02:45 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Maxim Uvarov <maxim.uvarov@oracle.com>
CC: Wim Van Sebroeck <wim@iguana.be>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        dann frazier <dannf@hp.com>
Subject: RE: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
Thread-Topic: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
Thread-Index: AQHM1AQmvgYktPlZTkqNjF1gWE474ZYcA0YAgAAEtwCAAAZWcIABub+AgAALDoA=
Date: Thu, 26 Jan 2012 00:01:14 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD3412332032F8AA@G9W0755.americas.hpqcorp.net>
References: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com>
 <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com>
 <CA+55aFxzfCxwYUcRbSyf+U7nr5GPjH4Qfine_TcY6Oxj8WQrWw@mail.gmail.com>
 <20120124203738.GA27296@infomag.iguana.be>
 <9774516974AF5F4C8A2C3C69CD3412332032E846@G9W0755.americas.hpqcorp.net>
 <4F208E73.3070103@oracle.com>
In-Reply-To: <4F208E73.3070103@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I will do this before the end of the week.


Tom

-----Original Message-----
From: Maxim Uvarov [mailto:maxim.uvarov@oracle.com] 
Sent: Wednesday, January 25, 2012 5:21 PM
To: Mingarelli, Thomas
Cc: Wim Van Sebroeck; Linus Torvalds; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; stable@vger.kernel.org; dann frazier
Subject: Re: [PATCH] hpwdt: clean up set_memory_x call for 32 bit

Thomas, will you be able to test patch accoring to  Linus's nr_page note?

Maxim.

On 01/24/2012 01:05 PM, Mingarelli, Thomas wrote:
> Yes I agree that Maxim's patch is correct. The original set_memory_x call for 64 bit was done correctly and the newer calls are wrong.
>
> The 2 pages for the BIOS SD is a known value so it should be safe to use as is.
>
>
>
> Tom
> -----Original Message-----
> From: Wim Van Sebroeck [mailto:wim@iguana.be]
> Sent: Tuesday, January 24, 2012 2:38 PM
> To: Linus Torvalds
> Cc: Maxim Uvarov; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; stable@vger.kernel.org; Mingarelli, Thomas; dann frazier
> Subject: Re: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
>
> Hi Linus,
>
>> So I don't know who is supposed to be handling this (Wim?), but the
>> patch itself looks suspicious.
>
> I asked Tom to look at Maxim's patch and see what it does. Tom was going to look at the patch and
> I'm waiting on feedback from him first. (That's why I din't sent it upstream yet).
>
>> On Sun, Jan 15, 2012 at 8:02 PM, Maxim Uvarov<maxim.uvarov@oracle.com>  wrote:
>>> -       set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
>>> +       set_memory_x((unsigned long)bios32_entrypoint&  PAGE_MASK, 2);
>>
>> If it wasn't page-aligned to begin with, then maybe it needs three pages now?
>>
>>> -                               set_memory_x((unsigned long)cru_rom_addr, cru_length);
>>> +                               set_memory_x((unsigned long)cru_rom_addr&  PAGE_MASK, cru_length>>  PAGE_SHIFT);
>>
>> Same here. If we align the start address down, we should fix up the
>> length. And should we not align the number of pages up?
>>
>> In general, a "start/length" conversion to a "page/nr" model needs to be roughly
>>
>>     len += start&  ~PAGE_MASK;
>>     start&= PAGE_MASK;
>>     nr_pages = (len + PAGE_SIZE - 1)>>  PAGE_SHIFT;
>>
>> to do things right. But I don't know where those magic numbers come
>> from. Maybe the "2" is already due to the code possibly traversing a
>> page boundary, and has already been fixed up. Somebody who knows the
>> driver and the requirements should take a look at this.
>
> Valid comments indeed. Tom please take Linus comments with you when you look at the patch.
>
> Dan: I put you in Cc: also so that you can have a look at it also.
>
> Kind regards,
> Wim.
>
>

