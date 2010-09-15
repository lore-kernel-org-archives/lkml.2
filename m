Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0IOTzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:55:52 -0400
Received: from mail3.networktest.com ([69.55.234.104]:46002 "EHLO
	mail3.networktest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0IOTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:55:51 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 15:55:51 EDT
Message-ID: <4C912264.5040203@networktest.com>
Date: Wed, 15 Sep 2010 12:45:40 -0700
From: David Newman <dnewman@networktest.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] drivers/net/tg3.c: Raise Jumbo Frame MTU to 9216?
References: <1284572516.10223.12.camel@Joe-Laptop>	 <1284573454.8929.221.camel@HP1> <1284578095.10223.27.camel@Joe-Laptop>
In-Reply-To: <1284578095.10223.27.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/10 12:14 PM, Joe Perches wrote:
> On Wed, 2010-09-15 at 10:57 -0700, Michael Chan wrote:
>> On Wed, 2010-09-15 at 10:41 -0700, Joe Perches wrote:
>>> The TG3 apparently supports 9K frame sizes.
>>> http://www.broadcom.com/collateral/pb/5704C-PB05-R.pdf
>>> Is exactly 9000 a hardware limit?
>>> Should the jumbo frame MTU be raised to 9216 or 9216
>>> less the size of MAC, VLAN, IP and TCP headers?
>> 9000 has been the de facto standard, has it been changed recently?
> 
> I know of a performance lab that's trying to use 9216 as a "standard"
> jumbo frame length.
> 
> Unrelated to the performance lab:
> http://www.uoregon.edu/~joe/jumbo-clean-gear.html
> 9216 seems popular, especially with Cisco gear.
> Contrary to that link, the Cisco 3750 does work with 9216 length
> jumbo frames.
> 
>> Anyway, we've never done any testing on 9216. 

9216 is commonly used in Ethernet switch testing [1]. Most data center
switches support it, including some built around Broadcom silicon (e.g.,
Dell PowerConnect 8024, Extreme Summit X650).

There is no IEEE standard for jumbo lengths. The IETF's RFC 5180
recommends 9216 for switch performance testing.

Although 5180 specs this length as a SHOULD and not a MUST, its use does
represent widespread industry practice in switch performance benchmarking.

Regards,
David Newman
Network Test

[1] Length from first byte of DA to last byte of CRC absent any VLAN
header(s).

