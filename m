Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1J0JKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:10:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56756 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1J0JKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:10:47 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>, "Michal Nazarewicz" <mina86@mina86.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] mm: MIGRATE_CMA migration type added
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-5-git-send-email-m.szyprowski@samsung.com>
 <20111018130826.GD6660@csn.ul.ie> <op.v3ve8vbl3l0zgt@mpn-glaptop>
Date: Thu, 27 Oct 2011 11:10:42 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3z6f4173l0zgt@mpn-glaptop>
In-Reply-To: <op.v3ve8vbl3l0zgt@mpn-glaptop>
User-Agent: Opera Mail/11.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 18 Oct 2011 06:08:26 -0700, Mel Gorman <mel@csn.ul.ie> wrote:
>> This does mean that MIGRATE_CMA also does not have a per-cpu list.
>> I don't know if that matters to you but all allocations using
>> MIGRATE_CMA will take the zone lock.

On Mon, 24 Oct 2011 21:32:45 +0200, Michal Nazarewicz <mina86@mina86.com> wrote:
> This is sort of an artefact of my misunderstanding of pcp lists in the
> past.  I'll have to re-evaluate the decision not to include CMA on pcp
> list.

Actually sorry.  My comment above is somehow invalid.

The CMA does not need to be on pcp list because CMA pages are never allocated
via standard kmalloc() and friends.  Because of the fallbacks in rmqueue_bulk()
the CMA pages end up being added to a pcp list of the MOVABLE type and so when
kmallec() allocates an MOVABLE page it can end up grabbing a CMA page.

So it's quite OK that CMA does not have its own pcp list as the list would
not be used anyway.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
