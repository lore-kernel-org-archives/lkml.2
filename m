Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2BEOdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 09:33:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33753 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2BEOdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 09:33:15 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Hillf Danton" <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 12/15] drivers: add Contiguous Memory Allocator
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <1328271538-14502-13-git-send-email-m.szyprowski@samsung.com>
 <CAJd=RBBPOwftZJUfe3xc6y24=T8un5hPk0wEOT_5v6WMCbDSag@mail.gmail.com>
Date: Sun, 05 Feb 2012 15:33:08 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v87mpive3l0zgt@mpn-glaptop>
In-Reply-To: <CAJd=RBBPOwftZJUfe3xc6y24=T8un5hPk0wEOT_5v6WMCbDSag@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Feb 2012 05:25:40 +0100, Hillf Danton <dhillf@gmail.com> wrote:
> Without boot mem reservation, what is the successful rate of CMA to
> serve requests of 1MiB, 2MiB, 4MiB and 8MiB chunks?

CMA will work as long as you manage to get some pageblocks marked as
MIGRATE_CMA and move all non-movable pages away.  You might try and get it
done after system has booted but we have not tried nor tested it.
Reservation at boot time lets us make sure that the portion of memory we
are grabbing has no unmovable pages.

You might still and use alloc_contig_pages() on its own (even without
MIGRATE_CMA) but that would require additional code which would look for
a region of memory that could be used (ie. that does not have unmovable
pages in it).  That in fact was what Kamezawa's code was doing.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
