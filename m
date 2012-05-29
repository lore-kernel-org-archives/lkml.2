Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2E2SRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:17:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41534 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2E2SRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:17:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FC50E09.4000204@zytor.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	<CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	<20120525193716.GA8817@google.com>
	<CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
	<CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
	<CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
	<CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
	<CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
	<4FC50E09.4000204@zytor.com>
Date: Tue, 29 May 2012 11:17:10 -0700
X-Google-Sender-Auth: OTewGZd3wMuJBtnzFd9kIj1YEsU
Message-ID: <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 10:57 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/29/2012 10:55 AM, Yinghai Lu wrote:
>>
>> x86 are using 16bits.
>>
>> some others use 32 bits.
>> #define IO_SPACE_LIMIT 0xffffffff
>>
>> ia64 and sparc are using 64bits.
>> #define IO_SPACE_LIMIT               0xffffffffffffffffUL
>>
>> but pci only support 16bits and 32bits.
>>
>> maybe later we can add
>> PCI_MAX_RESOURCE_16
>>
>> to handle 16bits and 32bit io ports.
>>
>
> Shouldn't this be dealt by root port apertures?
>

pci bridge could support 16bits and 32bits io port.
but we did not record if 32bits is supported.

so during allocating, could have allocated above 64k address to non
32bit bridge.

but  x86 is ok, because ioport.end always set to 0xffff.
other arches with IO_SPACE_LIMIT with 0xffffffff or
0xffffffffffffffffUL may have problem.

Yinghai
