Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2BMVd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:33:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61146 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2BMVdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:33:25 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Robert Nelson" <robertcnelson@gmail.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, "Ohad Ben-Cohen" <ohad@wizery.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Arnd Bergmann" <arnd@arndb.de>, "Jonathan Corbet" <corbet@lwn.net>,
        "Mel Gorman" <mel@csn.ul.ie>, "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Rob Clark" <rob.clark@linaro.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Linaro-mm-sig] [PATCHv21 12/16] mm: trigger page reclaim in
 alloc_contig_range() to stabilise watermarks
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
 <1328895151-5196-13-git-send-email-m.szyprowski@samsung.com>
 <CAOCHtYi01NVp1j=MX+0-z7ygW5tJuoswn8eWTQp+0Z5mMGdeQw@mail.gmail.com>
 <op.v9mt58ch3l0zgt@mpn-glaptop>
 <CAOCHtYjc39ThfrcAqdsxNf-bFqKzu=T8=O_W9Cg3cRNzQnX-OQ@mail.gmail.com>
Date: Mon, 13 Feb 2012 13:33:21 -0800
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9mzhvxt3l0zgt@mpn-glaptop>
In-Reply-To: <CAOCHtYjc39ThfrcAqdsxNf-bFqKzu=T8=O_W9Cg3cRNzQnX-OQ@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, Feb 10, 2012 at 11:32 AM, Marek Szyprowski
>>> +static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
>>> +{
>>> +       enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>>> +       struct zonelist *zonelist = node_zonelist(0, gfp_mask);
>>> +       int did_some_progress = 0;
>>> +       int order = 1;
>>> +       unsigned long watermark;
>>> +
>>> +       /*
>>> +        * Increase level of watermarks to force kswapd do his job
>>> +        * to stabilise at new watermark level.
>>> +        */
>>> +       __modify_min_cma_pages(zone, count);

> 2012/2/13 Michal Nazarewicz <mina86@mina86.com>:
>> This should read __update_cma_wmark_pages().  Sorry for the incorrect patch.

On Mon, 13 Feb 2012 13:15:13 -0800, Robert Nelson <robertcnelson@gmail.com> wrote:
> Thanks Michal, that fixed it..

You are most welcome.

> cma-v21 with Rob Clark's omapdrm works great on the Beagle xM..

Can we take that as:

Tested-by: Robert Nelson <robertcnelson@gmail.com>

? ;)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
