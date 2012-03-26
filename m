Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2CZPKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:10:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44656 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab2CZPKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120326135609.GM1007@csn.ul.ie>
References: <20120324130353.48f2e4c8@kryten>
	<20120324102621.353114da@annuminas.surriel.com>
	<20120326093201.GL1007@csn.ul.ie>
	<CAOJsxLGcoxxdhe2sNmAbC2e5afnZm9960XxBjY+QoCoc0RRb2w@mail.gmail.com>
	<20120326135609.GM1007@csn.ul.ie>
Date: Mon, 26 Mar 2012 18:10:13 +0300
X-Google-Sender-Auth: cq5-u-ezdsfIPMurCKvurQpCesM
Message-ID: <CAOJsxLHEHQOQsn9p8v6cq6SKM-E39WAy=CeaY=EN8gb9P5LEKQ@mail.gmail.com>
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

Hi Mel,

On Mon, Mar 26, 2012 at 4:56 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> The API looks fragile and this patch isn't exactly making it any
>> better. Why don't we make compaction_suitable() return something other
>> than COMPACT_SKIPPED for !CONFIG_COMPACTION case?
>
> Returning COMPACT_PARTIAL or COMPACT_CONTINUE would confuse the check in
> should_continue_reclaim. A fourth return type could be added but an
> obvious name does not spring to mind that would end up being similar to
> just adding a CONFIG_COMPACTION check.

How about COMPACT_DISABLED?

The current API just doesn't make sense from practical point of view.
Anyone calling compaction_suitable() needs to do the COMPAT_BUILD
check first which is a non-obvious and error-prone API.

                        Pekka
