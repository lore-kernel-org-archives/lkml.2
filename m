Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab0DMEFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:05:07 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:46267 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0DMEFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gl9kF/7Hz4D2+x+0XlPIDbC5rQMeTapLQdRWQ80rG8PWF7AJs5oDxDoWKoLoOwEi/v
         nJmOaoN/W9CvGN5WxwNn558pn8YPl8/mmEjfNS65FOfrctiD9MukYH1/IxIygcW0uolX
         wBN10TO5lcR9th3xEWNgOJqL96Xj+odqZ6Vn8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic>
	 <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
	 <20100412072056.GA2432@liondog.tnic>
	 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
	 <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic>
	 <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
Date: Tue, 13 Apr 2010 13:04:58 +0900
Message-ID: <o2n28c262361004122104k49d5b4fcs61c5d3a4cb6465c3@mail.gmail.com>
Subject: Re: [PATCH 1/4] Simplify and comment on anon_vma re-use for 
	anon_vma_prepare()
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 5:22 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 10 Apr 2010 10:36:19 -0700
> Subject: [PATCH 1/4] Simplify and comment on anon_vma re-use for anon_vma_prepare()
>
> This changes the anon_vma reuse case to require that we only reuse
> simple anon_vma's - ie the case when the vma only has a single anon_vma
> associated with it.
>
> This means that a reuse of an anon_vma from an adjacent vma will always
> guarantee that both vma's are associated not onyl with the same
> anon_vma, they will also have the same anon_vma chain (of just a single
> entry in this case).
>
> And since anon_vma re-use was the only case where the same anon_vma
> might be associated with different chains of anon_vma's, we now have the
> case that every vma that shares the same vma will always also have the

same vma => same anon_vma.

> same chain.  That makes it much easier to think about merging vma's that
> share the same anon_vma's: you can always just drop the other anon_vma
> chain in anon_vma_merge() since you know that they are always identical.
>
> This also splits up the function to validate the anon_vma re-use, and
> adds a lot of commentary about the possible races.
>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
