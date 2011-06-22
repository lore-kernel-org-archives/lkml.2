Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1FVPy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:54:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63111 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab1FVPyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=HG3tCq0b3IFa2ZwuMRFX7iYd/1o3e4kEKSg8sm3oXJvApZVyEmFr6Ukek+SGEXtD6o
         0/bmgzP/Pbc3F7LcW/1rb2nmw1jc4HInip5wD3rfd4cq5tQ8/E/0nuoFxVTSjo3F0Pp1
         7NapEb4xsPlLQX27g532NgvkMjCvjpbEbLF1g=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Hans Verkuil'" <hverkuil@xs4all.nl>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>
Cc: "'Daniel Walker'" <dwalker@codeaurora.org>,
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
 <201106150937.18524.arnd@arndb.de> <201106220903.31065.hverkuil@xs4all.nl>
 <201106221442.20848.arnd@arndb.de>
 <003701cc30de$7a159710$6e40c530$%szyprowski@samsung.com>
Date: Wed, 22 Jun 2011 17:54:47 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vxhihlc43l0zgt@mnazarewicz-glaptop>
In-Reply-To: <003701cc30de$7a159710$6e40c530$%szyprowski@samsung.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday, June 22, 2011 2:42 PM Arnd Bergmann wrote:
>> We could also go further and add a runtime sysctl mechanism like the
>> one for hugepages, where you can grow the pool at run time as long
>> as there is enough free contiguous memory (e.g. from init scripts),
>> or shrink it later if you want to allow larger nonmovable allocations.

On Wed, 22 Jun 2011 15:15:35 +0200, Marek Szyprowski wrote:
> Sounds really good, but it might be really hard to implement, at
> least for CMA, because it needs to tweak parameters of memory
> management internal structures very early, when buddy allocator
> has not been activated yet.

If you are able to allocate a pageblock of free memory from buddy system,
you should be able to convert it to CMA memory with no problems.

Also, if you want to convert CMA memory back to regular memory you
should be able to do that even if some of the memory is used by CMA
(it just won't be available right away but only when CMA frees it).

It is important to note that, because of the use of migration type,
all such conversion have to be performed on pageblock basis.

I don't think this is a feature we should consider for the first patch
though.  We started with an overgrown idea about what CMA might do
and it didn't got us far.  Let's first get the basics right and
then start implementing features as they become needed.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
