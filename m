Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0EBRkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:40:47 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:34001 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab0EBRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H6uovyVW8vGI7h6y3dOo8B6sRknOquRgiJixawGkMZ/BbEpTMyOhOomV0S9sni0YpF
         SGvXtqCfwCtU76p6MbYT10yxYm/UZHF+q6a/gG8VjErXlx0V1ogzqDMw3dRXh/OpoSZX
         lmo1WlMPLk4OpCioeDFYYqQWyGiiYA+e6/t0M=
MIME-Version: 1.0
In-Reply-To: <20100429162120.GC22108@random.random>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie>
	 <1272529930-29505-3-git-send-email-mel@csn.ul.ie>
	 <20100429162120.GC22108@random.random>
Date: Mon, 3 May 2010 02:40:44 +0900
Message-ID: <m2j28c262361005021040q118934b8j1f2f0146c9217a0f@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages() 
	and rmap_walk() during migration by not migrating temporary stacks
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 1:21 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hi Mel,
>
> did you see my proposed fix? I'm running with it applied, I'd be
> interested if you can test it. Surely it will also work for new
> anon-vma code in upstream, because at that point there's just 1
> anon-vma and nothing else attached to the vma.
>
> http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commit;h=6efa1dfa5152ef8d7f26beb188d6877525a9dd03
>
> I think it's wrong to try to handle the race in rmap walk by making
> magic checks on vm_flags VM_GROWSDOWN|GROWSUP and
> vma->vm_mm->map_count == 1, when we can fix it fully and simply in
> exec.c by indexing two vmas in the same anon-vma with a different
> vm_start so the pages will be found at all times by the rmap_walk.
>

I like this approach than exclude temporal stack while migration.

If we look it through viewpoint of performance, Mel and Kame's one
look good and simple. But If I look it through viewpoint of
correctness, Andrea's one looks good.
I mean Mel's approach is that problem is here but let us solve it with
there. it makes dependency between here and there. And In future, if
temporal stack and rmap code might be problem, we also should solve it
in there. :)

So I support this one.

-- 
Kind regards,
Minchan Kim
