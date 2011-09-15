Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951Ab1IOEDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 00:03:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1IOEDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 00:03:08 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
In-Reply-To: <1316047519.29510.122.camel@sli10-conroe>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com>
	 <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com>
	 <1315983230.2565.28.camel@edumazet-laptop>
	 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com>
	 <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com>
	 <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1315990519.29510.119.camel@sli10-conroe>
	 <alpine.LSU.2.00.1109141337080.29178@sister.anvils>
	 <1316033750.2835.2.camel@edumazet-laptop>
	 <alpine.LSU.2.00.1109141427190.29355@sister.anvils>
	 <CA+55aFyzjX9kkHZUVg=zZsOQjq1xoNBk2QvJjjnbUx3BOF5Fzg@mail.gmail.com>
	 <1316047519.29510.122.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 06:02:59 +0200
Message-ID: <1316059379.2835.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 08:45 +0800, Shaohua Li a écrit :

> here is my patch if you want to close the issue at hand.
> 
> Subject: mm: account skipped entries to avoid looping in find_get_pages
> 
> The found entries by find_get_pages() could be all swap entries. In
> this case we skip the entries, but make sure the skipped entries are
> accounted, so we don't keep looping.
> Using nr_found > nr_skip to simplify code as suggested by Eric.
> 
> Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 

Yep, I guess Hugh can refine it later.

I'm pulling latest Linus tree (including this patch) and redo a stress
session, including transparent hugepage games.

Thanks !


