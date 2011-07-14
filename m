Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1GNUjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:39:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37742 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab1GNUjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:39:00 -0400
Message-ID: <4E1F53D9.2000606@zytor.com>
Date: Thu, 14 Jul 2011 13:38:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
References: <1310462166-31469-1-git-send-email-tj@kernel.org>	<1310462166-31469-14-git-send-email-tj@kernel.org>	<4E1F4D2C.3000507@zytor.com>	<CAOS58YPhFWEYgB7moPoTj+BKBn6WMHCi5FqZ5eYp+m4bbEN_7A@mail.gmail.com>	<4E1F5040.50004@zytor.com> <CAOS58YM38mwmLcErARLc2+7wBrBa5Je3VOM5L28z63L6+ysqpQ@mail.gmail.com>
In-Reply-To: <CAOS58YM38mwmLcErARLc2+7wBrBa5Je3VOM5L28z63L6+ysqpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 01:32 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 14, 2011 at 10:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/14/2011 01:20 PM, Tejun Heo wrote:
>> Sorry I don't follow.  We display resources as [...] ranges, and in
>> particular when there are those kinds of brackets they tend to be
>> inclusive ranges.
>>
>> For the internal representation, of course, [ ) ranges or (base, length)
>> are the only sensible options.
> 
> [ ) ranges: e820, init_memory_mapping, NUMA nodes, Zone PFN ranges, PM
> nosave memory
> 
> [ ] ranges: MTRR, NODE_DATA, early_node_map, [mm]io ranges
> 
> Hmm... I was only looking at the early boot messages which didn't
> include the io ranges.  It ultimately is a cosmetic issue so my
> opinions aren't very strong but I think we can leave [mm]io ranges
> alone and converge the rest into [ ) ranges sans the brackets?
> 

Agreed it's a cosmetic issue... this discussion has already been had,
though, and the consensus is to move the kernel to the standardized
resource format.

	-hpa
