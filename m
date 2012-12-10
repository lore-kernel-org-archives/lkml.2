Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2LJKhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:37:14 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:35081 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2LJKhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:37:13 -0500
Message-ID: <50C5BB4A.9000403@synopsys.com>
Date: Mon, 10 Dec 2012 16:06:58 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Noam Camus <noamc@ezchip.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Makefile race between jobs
References: <264C179F799EF24AB26D5319053335E80CC3049A10@ezexch.ezchip.com> <50C4B8F3.6030704@suse.cz> <264C179F799EF24AB26D5319053335E80CC31B9D41@ezexch.ezchip.com> <20121210094515.GA31121@sepie.suse.cz> <50C5B54B.5080806@synopsys.com> <50C5B9D9.1080208@suse.cz>
In-Reply-To: <50C5B9D9.1080208@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 04:00 PM, Michal Marek wrote:
> On 10.12.2012 11:11, Vineet Gupta wrote:
>> ARC Port caches current task pointer in a register - thus we have a
>> global asm register definition in current.h
>> In the past, a customer ran into issue when porting some "really
>> portable" code to kernel - such that asm/current.h didn't make it into
>> the build of their module - via normal header includes - strange but
>> true. Thus forcing current.h via way of -include seemed like a
>> safe/sensible way.
> 
> To me that sounds like either an arc header is using the define but
> lacking an include of asm/current.h, or the code is lacking asm/current.h.
> 

It was latter - customer code was lacking include of asm/current.h
At any rate, independent of above, since we are dealing with a global
reg definition, IMHO, forcing the -include for each file built ensures
the generated code correctness (gcc reg allocator not fiddling with that
reg) - w/o "assuming" it would.

-Vineet

> Michal
