Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0FLS3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 14:29:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47254 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0FLS3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 14:29:20 -0400
Message-ID: <4C13D1E7.7060604@zytor.com>
Date: Sat, 12 Jun 2010 11:28:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: x86@kernel.org, Josh Triplett <josh@joshtriplett.org>,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
References: <20100612060322.29053.94187.reportbug@feather> <1276351120.14011.194.camel@localhost>
In-Reply-To: <1276351120.14011.194.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2010 06:58 AM, Ben Hutchings wrote:
> Josh Triplett reported this problem with memory sizing:
> 
>>
>> A kernel built from c549e71d073a6e9a4847497344db28a784061455 finds <64MB
>> of RAM; a kernel built from c549e71d073a6e9a4847497344db28a784061455^
>> successfully finds all 4GB of RAM.
>>
>> Also note that newer upstream kernels, including v2.6.35-rc3, fail as
>> well.  Since later kernels revert part of the above commit, the issue
>> must lie with the parts of the commit not reverted.
>>
>> And, again, I can reproduce this using the stock upstream GRUB2 1.98
>> release built from source, by booting it from a USB key, and then
>> booting the disk MBR via:
>>
>> set root=(hd1)
>> drivemap (hd1) (hd0)
>> chainloader +1
>> boot
>>
>> Nothing special about drivemap here; anything that uses grub's mmap
>> module to reserve memory via e820 (GRUB_MACHINE_MEMORY_RESERVED) will
>> cause grub to hook e820 and trigger this bug.  However, in stock grub,
>> only drivemap does this.
>>

It's kind of hard to know what is involved, since clearly it relates to
Grub2, which -- how do I say this politely -- seems to excel at doing
things in the most inferior way possible.  This is a great example of that.

The most likely reason it fails is because Grub2 uses ACPI 3-style reads
of the board memory map, gets wrong results for the same reasons the
kernel do, and then pass then downstream to the kernel.  As such, there
is absolutely nothing the kernel can do about it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

