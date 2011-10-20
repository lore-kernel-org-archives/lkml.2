Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1JTWoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 18:44:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34188 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1JTWoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 18:44:12 -0400
Message-ID: <4EA0A424.3030907@zytor.com>
Date: Thu, 20 Oct 2011 15:43:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai.lu@oracle.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>  <m2sjmnxsi3.fsf@firstfloor.org> <4EA092DD.8020203@zytor.com> <1319148647.13035.4.camel@jshin-Toonie>
In-Reply-To: <1319148647.13035.4.camel@jshin-Toonie>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 03:10 PM, Jacob Shin wrote:
> On Thu, 2011-10-20 at 16:30 -0500, H. Peter Anvin wrote:
>> On 10/20/2011 02:28 PM, Andi Kleen wrote:
>>> Jacob Shin <jacob.shin@amd.com> writes:
>>>
>>>> On systems with very large memory (1 TB in our case), BIOS may report a
>>>> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
>>>> these from the direct mapping.
>>>
>>> This doesn't make much sense.  Holes above 4GB are completely legal.
>>>
>>> If you need to workaround a specific broken BIOS you would need a quirk
>>> only matching that system, with a suitable "BIOS is broken" message.
>>>
>>
>> The problem is that apparently right now we map those unconditionally
>> into the 1:1 map and mark them cacheable in PAT, which we *don't* for
>> the < 4 GiB map.
>>
>> This thus makes the behavior match < 4 GiB, which is the correct
>> behavior; this should be made clear in the patch description.
> 
> Will something like:
> 
> "On systems with very large memory (1 TB in our case), BIOS may report a
> reserved region or a hole in the E820 map, even above the 4 GB range.
> Avoid mapping them unconditionally into kernel 1:1 direct mapping as
> cacheable memory, as we also already do for the MMIO hole under 4 GB."
> 
> Work?
> 
> Otherwise, does the patch look acceptable?
> 

Drop the first half, and stop talking about "the MMIO hole" or anything
else with a definite article.

We're either doing this correctly for all holes or we have a bug.  If we
have a bug we should fix it in a general way, and I'm not convinced that
your patch is general enough.

I'm very bandwidth-constrained between kernel.org remediation and about
to leave for kernel summit, so I'm not sure how much detail I can look
into it right now.

	-hpa

