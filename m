Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2E2UvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 16:51:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57178 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab2E2UvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 16:51:11 -0400
Message-ID: <4FC536A5.6020600@zytor.com>
Date: Tue, 29 May 2012 13:50:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org> <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com> <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com> <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com> <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com> <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com> <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com> <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com> <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com> <CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com> <4FC50E09.4000204@zytor.com> <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com> <4FC51D79.6010804@zytor.com> <CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
In-Reply-To: <CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 01:46 PM, Yinghai Lu wrote:
> On Tue, May 29, 2012 at 12:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/29/2012 11:17 AM, Yinghai Lu wrote:
>>>
>>> pci bridge could support 16bits and 32bits io port.
>>> but we did not record if 32bits is supported.
>>>
>>
>> Okay, so this is the actual problem, no?
> 
> their fw could not need kernel help to allocate io ports, or they are
> only use device that support 32bit ioport.
> 

That barely parses, never mind makes sense.

>>
>>> so during allocating, could have allocated above 64k address to non
>>> 32bit bridge.
>>>
>>> but  x86 is ok, because ioport.end always set to 0xffff.
>>> other arches with IO_SPACE_LIMIT with 0xffffffff or
>>> 0xffffffffffffffffUL may have problem.
>>
>> The latter is nonsense, the PCI-side address space is only 32 bits wide.
>>
> maybe they have unified io include ioport and mem io?
> 

The bus-side address space should not be more than 32 bits no matter
what.  As Bjorn indicates, you seem to be mixing up bus and cpu
addresses all over the place.

	-hpa

