Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0FLUl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 16:41:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47785 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0FLUl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 16:41:58 -0400
Message-ID: <4C13F102.7000509@zytor.com>
Date: Sat, 12 Jun 2010 13:41:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
References: <20100612060322.29053.94187.reportbug@feather> <1276351120.14011.194.camel@localhost> <4C13D1E7.7060604@zytor.com> <20100612185538.GA4511@feather>
In-Reply-To: <20100612185538.GA4511@feather>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2010 11:55 AM, Josh Triplett wrote:
>>
>> It's kind of hard to know what is involved, since clearly it relates to
>> Grub2, which -- how do I say this politely -- seems to excel at doing
>> things in the most inferior way possible.  This is a great example of that.
>>
>> The most likely reason it fails is because Grub2 uses ACPI 3-style reads
>> of the board memory map, gets wrong results for the same reasons the
>> kernel do, and then pass then downstream to the kernel.  As such, there
>> is absolutely nothing the kernel can do about it.
> 
> grub2 doesn't do ACPI 3 reads; it always asks for 20 bytes, not 24.
> 
> Also, note that it works with older Linux kernels (before the commit in
> question) and fails with newer ones.  That doesn't rule out the
> possibility of a grub bug instead of a Linux bug, but since older Linux
> somehow coped with the situation, it seems like a regression that newer
> Linux cannot cope.
> 

It's a regression of sorts, sure; but the new Linux code also boots on
real hardware which it didn't boot before.  Since this requires Grub2
plus specific hardware, it is hard for me to track down what the problem
might be, but a good step on the way might be to use the Grub2 boot
procedure (with the drive remapping) to chainboot Syslinux, and run
meminfo.c32 which is a memory report debugging tool; it might be able to
give some answers at least.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

