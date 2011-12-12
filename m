Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1LLXK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:10:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43065 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1LLXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:10:54 -0500
Message-ID: <4EE689D5.4070600@zytor.com>
Date: Mon, 12 Dec 2011 15:10:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mike Waychison <mikew@google.com>,
        Andi Kleen <andi@firstfloor.org>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86, efi: Break up large initrd reads
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com>  <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECE5803.3060203@gmail.com>  <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECEF144.8020303@gmail.com> <1322210899.24448.66.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1322210899.24448.66.camel@mfleming-mobl1.ger.corp.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 12:48 AM, Matt Fleming wrote:
> On Fri, 2011-11-25 at 02:37 +0100, Maarten Lankhorst wrote:
>> The efi boot stub tries to read the entire initrd in 1 go,
>> however some efi implementations hang if too much if asked
>> to read too much data at the same time. After some
>> experimentation I found out that my asrock p67 board will
>> hang if asked to read chunks of 4mb, so use a safe value.
>>
>> From elilo source code:
>> /*
>>  * We load by chunks rather than a single big read because
>>  * early versions of EFI had troubles loading files
>>  * from floppies in a single big request.  Breaking
>>  * the read down into chunks of 4KB fixed that
>>  * problem. While this problem has been fixed, we still prefer
>>  * this method because it tells us whether or not we're making
>>  * forward progress.
>>  */
>>
>> While the comment says 4KB, it's using 4 * EFI_PAGE_SIZE (16KB),
>> so I went by the safest route of following elilo here.
>>

I'm going to NAK this, because I think the performance impact is too
severe.  I would like to set the cap at 1 MiB for now, unless we can
identify platforms where *that* is known to fail.

Maarten, would you be willing to rev your patch?  Furthermore, please
make the maximum chunksize a define.

	-hpa

