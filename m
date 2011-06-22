Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab1FVQEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:04:48 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46384 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab1FVQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=eQPrYVo9mAM006RoJjxh+GGLSpk8me8bpedq/1HjO/DmHS2gqFLlUzQoFmjmvXb/bK
         yQISoENicXO7TxNs832RjERwPYBnrqZY1hDcxdv3zUHRDvUVT0EtrnBBmh8OcTMw8ZSh
         YnqPXWXhTr5fEAuy2CyBFrT83x1XkGcRLIFbg=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Cc: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106221442.20848.arnd@arndb.de>
 <003701cc30de$7a159710$6e40c530$%szyprowski@samsung.com>
 <201106221539.24044.arnd@arndb.de>
Date: Wed, 22 Jun 2011 18:04:39 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vxhix1zu3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106221539.24044.arnd@arndb.de>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 15:39:23 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> Why that? I would expect you can do the same that hugepages (used to) do
> and just attempt high-order allocations. If they succeed, you can add  
> them as a CMA region and free them again, into the movable set of pages,  
> otherwise you just fail the  request from user space when the memory is
> already fragmented.

Problem with that is that CMA needs to have whole pageblocks allocated
and buddy can allocate at most half a pageblock.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
