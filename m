Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2GPSlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:41:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49395 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2GPSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <871ukbr4d3.fsf@erwin.mina86.com>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
	<1342455272-32703-3-git-send-email-js1304@gmail.com>
	<871ukbr4d3.fsf@erwin.mina86.com>
Date: Tue, 17 Jul 2012 03:40:56 +0900
Message-ID: <CAAmzW4MpWsxd2nG-xsdw_D89-Prx7PPuWSEbuS7Nw0rTmcChig@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: fix return value in __alloc_contig_migrate_range()
From: JoonSoo Kim <js1304@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/17 Michal Nazarewicz <mina86@mina86.com>:
> Joonsoo Kim <js1304@gmail.com> writes:
>
>> migrate_pages() would return positive value in some failure case,
>> so 'ret > 0 ? 0 : ret' may be wrong.
>> This fix it and remove one dead statement.
>>
>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Christoph Lameter <cl@linux.com>
>
> Have you actually encountered this problem?  If migrate_pages() fails
> with a positive value, the code that you are removing kicks in and
> -EBUSY is assigned to ret (now that I look at it, I think that in the
> current code the "return ret > 0 ? 0 : ret;" statement could be reduced
> to "return ret;").  Your code seems to be cleaner, but the commit
> message does not look accurate to me.
>

I don't encounter this problem yet.

If migrate_pages() with offlining false meets KSM page, then migration failed.
In this case, failed page is removed from cc.migratepage list and
return failed count.
So it can be possible exiting loop without testing ++tries == 5 and
ret is over the zero.
Is there any point which I missing?
Is there any possible scenario "migrate_pages return  > 0 and
cc.migratepages is empty"?

I'm not expert for MM, so please comment my humble opinion.
