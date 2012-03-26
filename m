Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2CZKkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:40:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47604 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab2CZKkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120326093201.GL1007@csn.ul.ie>
References: <20120324130353.48f2e4c8@kryten>
	<20120324102621.353114da@annuminas.surriel.com>
	<20120326093201.GL1007@csn.ul.ie>
Date: Mon, 26 Mar 2012 13:40:41 +0300
X-Google-Sender-Auth: oZ7TpAjsShvhCgvtL_aDvIGmHU4
Message-ID: <CAOJsxLGcoxxdhe2sNmAbC2e5afnZm9960XxBjY+QoCoc0RRb2w@mail.gmail.com>
Subject: Re: [PATCH] Re: kswapd stuck using 100% CPU
From: Pekka Enberg <penberg@kernel.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Anton Blanchard <anton@samba.org>,
        aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:32 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Sat, Mar 24, 2012 at 10:26:21AM -0400, Rik van Riel wrote:
>>
>> Only test compaction_suitable if the kernel is built with CONFIG_COMPACTION,
>> otherwise the stub compaction_suitable function will always return
>> COMPACT_SKIPPED and send kswapd into an infinite loop.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Reported-by: Anton Blanchard <anton@samba.org>
>
> Acked-by: Mel Gorman <mel@csn.ul.ie>

The API looks fragile and this patch isn't exactly making it any
better. Why don't we make compaction_suitable() return something other
than COMPACT_SKIPPED for !CONFIG_COMPACTION case?

                        Pekka
