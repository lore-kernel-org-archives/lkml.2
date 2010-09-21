Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0IUOiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:38:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0IUOiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:38:08 -0400
Message-ID: <38667ac18ee6604649af9396cf156182.squirrel@www.firstfloor.org>
In-Reply-To: <20100921141329.GU13563@erda.amd.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
    <201009211321.06172.arnd@arndb.de>
    <20100921141329.GU13563@erda.amd.com>
Date: Tue, 21 Sep 2010 16:38:04 +0200
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
From: "Andi Kleen" <andi@firstfloor.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Jiri Olsa" <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>,
        "Andi Kleen" <andi@firstfloor.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 21.09.10 07:21:05, Arnd Bergmann wrote:
>> Just curious about the other missing IDs: this now supports all Core
>> microarchitecture CPUs, but only some Nehalem/Westmere ones.
>>
>> There is support for 0x1a (Bloomfield/Gainestown) and 0x2e (Beckton),
>> but
>> not for the much more common 0x1e (Lynnfield/Clarksfield/Jasper Forest),
>> 0x25 (Clarkdale/Arrandale) and 0x26 (Gulftown/Westmere-EP).
>>
>> Shouldn't those be added as well?

Westmere I still hold off because the oprofile user land
doesn't have the correct event list yet.

BTW I was thinking in this case to only add the model
numbers to the user code and just let it handle arch_perfmon
from the kernel.

This should work currently fine and avoid the problem
that you need to update user land and kernel in parallel
for a new cpu type.

>>
>> When you're there, it probably also wouldn't hurt to fill in the blanks
>> of some of the older CPUs like Tolopai (0x15) and newer Atoms (0x1c).
>
> Yes, would be nice to have also an update for the remaining
> unsupported models. Andi?

Yes would make sense. I'll ask around if there is a consolidated
list somewhere that could be used as a base.

-Andi

