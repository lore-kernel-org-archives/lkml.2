Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1J3Vxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 17:53:48 -0400
Received: from smtp1.newsguy.com ([74.209.136.71]:56615 "EHLO
	smtp1.newsguy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1J3Vxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 17:53:47 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Oct 2011 17:53:47 EDT
Message-ID: <4EADC4F5.2050201@newsguy.com>
Date: Sun, 30 Oct 2011 14:43:17 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: Marek Vasut <marek.vasut@gmail.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, dedekind1@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13]  DocG3 fixes and write support
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>	<201110300241.39534.marek.vasut@gmail.com> <87bosy6eab.fsf@free.fr>
In-Reply-To: <87bosy6eab.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,


On 10/30/2011 02:04 AM, Robert Jarzmik wrote:
> Marek Vasut <marek.vasut@gmail.com> writes:
>
>> Hi,
>>
>> can you sum up the situation about the another (docg4) driver for us not 
>> watching this too tightly? Was there any improvement/progress/... ?
> The review is underway, my comments should be dealt with, and a V2 of the patch
> should be sent. It's not in my hands.


I've been busy working on this, and should post a patch within the next few
days.  Progress has been very good.  I still want to run the mtd tests in the
kernel before posting the patch (except the torture test - I'm not ready to
sacrifice my development Treo), but it continues to pass the nandtest userspace
utility (part of mtd-utils) flawlessly, and a ubifs still appears to be working
well.  The code is now in a much cleaner state.


> The global view we have with Mike is that chips are different, and each one
> deserves its own driver. Several registers are common, and the docg3.h could
> become common.
>

Actually, I'm open on this.  My opinion is that they should share a header file
for sure, because the register set largely overlaps.  To that end, my upcoming
patch will adopt Robert's register #defines, with just a few additional ones
that are G4 specific.

On the broader question of combined or separate drivers... a combined driver is
certainly doable.  Each device would have to use its own set of low-level
functions, but I think there's merit in combining them because it would provide
a consistent interface with the mtd nand infrastructure code, which is rather
messy.  But before that discussion can take place, the more fundamental question
of whether or not the drivers should use the nand interface needs to be
resolved.  I used the nand interface when I started on the G4 driver, because it
*is* a nand device, and the legacy diskonchip.c driver was updated not long ago
from a stand-alone driver to the nand interface.  I'm not knowledgeable enough
of the mtd subsystem to argue for or against the nand interface, but the end
result (once I invested the time slogging through nand_base.c) is fairly clean,
with just a couple minor hacks to get around the fact that it doesnt have a
"standard" nand controller.

Hopefully some mtd experts can share an opinion on this.

Thanks,
Mike

