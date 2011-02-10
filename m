Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1BJNKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:10:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1BJNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=weD019IeD3NxUPQkvI/nNH3ZT3YIDKpa5cPGkh6hxB6KnTUzaW3lO/oJFKG2SGR0Nq
         hs29esLF6bF7a4EPWln95yO9SJe5GDLYoJL2e2R9FpIUnBfvtlxl0MGkagz+PnDJDn00
         9lIioCPfMIG2E1mjlO+Rtg5/cp2fbkHNbkTD0=
MIME-Version: 1.0
In-Reply-To: <1297338408-3590-1-git-send-email-namhyung@gmail.com>
References: <1297338408-3590-1-git-send-email-namhyung@gmail.com>
Date: Thu, 10 Feb 2011 22:10:38 +0900
Message-ID: <AANLkTikEigbPsNMqqkmixYbCfD7Dz12YMcW2+GZbhUQq@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: handle simple case in free_pcppages_bulk()
From: Minchan Kim <minchan.kim@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Namhyung,

On Thu, Feb 10, 2011 at 8:46 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Now I'm seeing that there are some cases to free all pages in a
> pcp lists. In that case, just frees all pages in the lists instead
> of being bothered with round-robin lists traversal.

I though about that but I didn't send the patch.
That's because many cases which calls free_pcppages_bulk(,
pcp->count,..) are slow path so it adds comparison overhead on fast
path while it loses the effectiveness in slow path.

-- 
Kind regards,
Minchan Kim
