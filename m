Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab2BJUNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:13:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48963 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab2BJUNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:13:10 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dan Smith" <danms@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are
 page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
 <op.v9hahmw23l0zgt@mpn-glaptop> <874nuy31hw.fsf@caffeine.danplanet.com>
Date: Fri, 10 Feb 2012 21:13:07 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9hbr5xx3l0zgt@mpn-glaptop>
In-Reply-To: <874nuy31hw.fsf@caffeine.danplanet.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 20:57:31 +0100, Dan Smith <danms@us.ibm.com> wrote:
> MN> Commit message says about walk_pte_range() but commit changes
> MN> walk_page_range().
>
> Yep, the issue occurs in walk_pte_range().

OK, it wasn't immediately obvious for me that while loop in walk_page_range()
will actually recover if arguments are not aligned (since pgd_addr_end() caps
returned value).

> The goal was to ensure that
> the external interface to it (which is walk_page_range()) does the check
> and avoids doing the walk entirely. I think the expectation is that
> walk_page_range() is used on aligned addresses. If we put the check in
> walk_pte_range() then only walks with a pte_entry handler would fail on
> unaligned addresses, which is potentially confusing.
>
> MN> So why not change the condition to addr < end?
>
> That would work, of course, but seems sloppier and less precise. The
> existing code was clearly written expecting to walk aligned addresses.

Fair enough.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
