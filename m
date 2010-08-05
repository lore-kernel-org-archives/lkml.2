Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab0HEP1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:27:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47909 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215Ab0HEP1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:27:43 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm\@opensource.se" <damm@opensource.se>,
        "lethal\@linux-sh.org" <lethal@linux-sh.org>,
        "rjw\@sisk.pl" <rjw@sisk.pl>,
        "eric.y.miao\@gmail.com" <eric.y.miao@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alan@lxorguk.ukuu.org.uk,
        zt.tmzt@gmail.com
Subject: Re: [PATCH] platform: Facilitate the creation of pseduo-platform  busses
Organization: Deep Root Systems, LLC
References: <4C59E654.1090403@codeaurora.org>
	<AANLkTimkMy6_201XNGb41e7LivkvVHMkFZWVoA-7UmBo@mail.gmail.com>
Date: Thu, 05 Aug 2010 08:27:39 -0700
In-Reply-To: <AANLkTimkMy6_201XNGb41e7LivkvVHMkFZWVoA-7UmBo@mail.gmail.com>
	(Magnus Damm's message of "Thu, 5 Aug 2010 11:32:16 +0900")
Message-ID: <87fwyt13mc.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm <magnus.damm@gmail.com> writes:

> On Thu, Aug 5, 2010 at 7:14 AM, Patrick Pannuto <ppannuto@codeaurora.org> wrote:
>> Inspiration for this comes from:
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg31161.html
>>
>> RFC: http://lkml.org/lkml/2010/8/3/496
>> Patch is unchanged from the RFC. Reviews seemed generally positive
>> and it seemed this was desired functionality.
>
> Thanks for your patch, it's really nice to see work done in this area!
> I'd like to see something like this merged in the not so distant
> future. At this point I'm not so concerned about the details, so I'll
> restrict myself to this:
>
>> /drivers/my_driver.c
>>        static struct platform_driver my_driver = {
>>                .driver = {
>>                        .name   = "my-driver",
>>                        .owner  = THIS_MODULE,
>>                        .bus    = &my_bus_type,
>>                },
>>        };
>
> I would really prefer not to have the bus type in the here. I
> understand it's needed at this point, but I wonder if it's possible to
> adjust the device<->driver matching for platform devices to allow any
> type of pseudo-platform bus_type.

I totally agree here.  Keeping the drivers ignorant of the bus (or SoC)
they are on will make them much more portable.

Kevin
