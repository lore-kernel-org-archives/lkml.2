Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0G0WdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:33:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47431 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0G0WdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uaIbWDjnG4l40xZwNjFEukRARizEP9hO6F4JEzQ43bilwt1hqbKgimSICBRRDlDVlW
         M04dHhKpZmJDyKYt7rggePp2FrvwUNsCwB6IMvAuiKme0Otdn4/JJrIBsbNQJVJ+JICd
         HX/sc9IGC3UH8e8brGKbQusslMdVv1ijaSo5Y=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007270929290.28648@router.home>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1007261136160.5438@router.home>
	<pfn.valid.v4.reply.1@mdm.bga.com>
	<AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com>
	<pfn.valid.v4.reply.2@mdm.bga.com>
	<20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
	<alpine.DEB.2.00.1007270929290.28648@router.home>
Date: Wed, 28 Jul 2010 07:33:07 +0900
Message-ID: <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 11:34 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 27 Jul 2010, Minchan Kim wrote:
>
>> But in fact I have a concern to use PG_reserved since it can be used
>> afterward pfn_valid normally to check hole in non-hole system. So I
>> think it's redundant.

Ignore me. I got confused.

>
> PG_reserved is already used to mark pages not handled by the page
> allocator (see mmap_init_zone).


I will resend below approach.

static inline int memmap_valid(unsigned long pfn)
{
       struct page *page = pfn_to_page(pfn);
       struct page *__pg = virt_to_page(page);
       return page_private(__pg) == MAGIC_MEMMAP && PageReserved(__pg);
}

Thanks, all.


-- 
Kind regards,
Minchan Kim
