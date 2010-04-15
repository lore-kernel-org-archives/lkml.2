Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0DOQCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:02:11 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50677 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0DOQCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iEDBnG6E4SuP16SIbCqui6vNU3p0UDAk5Qo1nkxYcCbHigdbxMngSkQ1TjwhapOQjU
         i+QbtaaPycdMqhKTqpAzQ0/H3bmlryWHca3PEvZEWiAZzRkrF0+T2HRZkLdFFNvIK2tS
         Bfq4jlqpfvXyQ1Wx54LLq+oRPmq2MIgw8U8qg=
MIME-Version: 1.0
In-Reply-To: <20100414175928.5e1bdce2@annuminas.surriel.com>
References: <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
	 <20100412072056.GA2432@liondog.tnic>
	 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
	 <20100412215027.GA6263@liondog.tnic>
	 <alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org>
	 <20100413093827.GA6954@liondog.tnic>
	 <20100414175928.5e1bdce2@annuminas.surriel.com>
Date: Fri, 16 Apr 2010 01:02:08 +0900
Message-ID: <k2r28c262361004150902tff8e6d2fvc64bcdc496ba699e@mail.gmail.com>
Subject: Re: [PATCH] rmap: add exclusively owned pages to the newest anon_vma
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 6:59 AM, Rik van Riel <riel@redhat.com> wrote:
> The recent anon_vma fixes cause many anonymous pages to end up
> in the parent process anon_vma, even when the page is exclusively
> owned by the current process.
>
> Adding exclusively owned anonymous pages to the top anon_vma
> reduces rmap scanning overhead, especially in workloads with
> forking servers.
>
> This patch adds a parameter to __page_set_anon_rmap that can
> be used to indicate whether or not the added page is exclusively
> owned by the current process.
>
> Pages added through page_add_new_anon_rmap are exclusively
> owned by the current process, and can be added to the top
> anon_vma.
>
> Pages added through page_add_anon_rmap can be either shared
> or exclusively owned, so we do the conservative thing and
> add it to the oldest anon_vma.
>
> A next step would be to add the exclusive parameter to
> page_add_anon_rmap, to be used from functions where we do
> know for sure whether a page is exclusively owned.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
