Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2GQPpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:45:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57491 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2GQPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <op.whld71os3l0zgt@mpn-glaptop>
References: <1342528415-2291-1-git-send-email-js1304@gmail.com>
	<1342528415-2291-3-git-send-email-js1304@gmail.com>
	<op.whld71os3l0zgt@mpn-glaptop>
Date: Wed, 18 Jul 2012 00:45:42 +0900
Message-ID: <CAAmzW4N+CJGnn3a6PUQZAeEeb4njp_zwXMhOSdSrHc36OLsDjg@mail.gmail.com>
Subject: Re: [PATCH 3/4 v2] mm: fix return value in __alloc_contig_migrate_range()
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
> On Tue, 17 Jul 2012 14:33:34 +0200, Joonsoo Kim <js1304@gmail.com> wrote:
>>
>> migrate_pages() would return positive value in some failure case,
>> so 'ret > 0 ? 0 : ret' may be wrong.
>> This fix it and remove one dead statement.
>
>
> How about the following message:
>
> ------------------- >8 ---------------------------------------------------
> migrate_pages() can return positive value while at the same time emptying
> the list of pages it was called with.  Such situation means that it went
> through all the pages on the list some of which failed to be migrated.
>
> If that happens, __alloc_contig_migrate_range()'s loop may finish without
> "++tries == 5" never being checked.  This in turn means that at the end
> of the function, ret may have a positive value, which should be treated
> as an error.
>
> This patch changes __alloc_contig_migrate_range() so that the return
> statement converts positive ret value into -EBUSY error.
> ------------------- >8 ---------------------------------------------------

It's good.
I will resend patch replacing my comment with yours.
Thanks for help.
