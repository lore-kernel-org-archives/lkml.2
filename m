Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1JTVdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33766 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1JTVdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:33:04 -0400
Message-ID: <4EA0937F.3040400@zytor.com>
Date: Thu, 20 Oct 2011 14:32:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai.lu@oracle.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com> <m2sjmnxsi3.fsf@firstfloor.org> <4EA092DD.8020203@zytor.com>
In-Reply-To: <4EA092DD.8020203@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 02:30 PM, H. Peter Anvin wrote:
> On 10/20/2011 02:28 PM, Andi Kleen wrote:
>> Jacob Shin <jacob.shin@amd.com> writes:
>>
>>> On systems with very large memory (1 TB in our case), BIOS may report a
>>> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
>>> these from the direct mapping.
>>
>> This doesn't make much sense.  Holes above 4GB are completely legal.
>>
>> If you need to workaround a specific broken BIOS you would need a quirk
>> only matching that system, with a suitable "BIOS is broken" message.
>>
> 
> The problem is that apparently right now we map those unconditionally
> into the 1:1 map and mark them cacheable in PAT, which we *don't* for
> the < 4 GiB map.
> 
> This thus makes the behavior match < 4 GiB, which is the correct
> behavior; this should be made clear in the patch description.
> 

Specifically, it's fine for them to be mapped; it's not fine for them to
be mapped cacheable.

	-hpa

