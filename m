Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab1LNWnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:43:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34508 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1LNWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:43:07 -0500
Message-ID: <4EE9266A.90200@zytor.com>
Date: Wed, 14 Dec 2011 14:42:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai.lu@oracle.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>  <4EA09EA2.3030203@zytor.com> <1319149574.13035.6.camel@jshin-Toonie>
In-Reply-To: <1319149574.13035.6.camel@jshin-Toonie>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 03:26 PM, Jacob Shin wrote:
> On Thu, 2011-10-20 at 17:20 -0500, H. Peter Anvin wrote:
>> On 10/20/2011 02:15 PM, Jacob Shin wrote:
>>> On systems with very large memory (1 TB in our case), BIOS may report a
>>> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
>>> these from the direct mapping.
>>
>>> +			if (ei->type == E820_RESERVED)
>>> +				continue;
>>
>> This should probably be ei->type != E820_RAM or something similar.  I
>> haven't looked yet, what does the < 4 GiB code do?
> 
> Hm, okay, it calls e820_end_of_low_ram_pfn() which effectively is !=
> E820_RAM.
> 
> I'll fix this, test, then resend.
> 

I never got any kind of updated patch, did I?

	-hpa

