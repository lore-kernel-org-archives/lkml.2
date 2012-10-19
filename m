Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2JSJ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:28:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53787 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2JSJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:28:45 -0400
Date: Fri, 19 Oct 2012 02:28:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7 v3] mm, mempolicy: hold task->mempolicy refcount
 while reading numa_maps.
In-Reply-To: <508110C4.6030805@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210190227240.26815@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
 <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <20121017181413.GA16805@redhat.com> <alpine.DEB.2.00.1210171219010.28214@chino.kir.corp.google.com> <20121017193229.GC16805@redhat.com>
 <alpine.DEB.2.00.1210171237130.28214@chino.kir.corp.google.com> <20121017194501.GA24400@redhat.com> <alpine.DEB.2.00.1210171318400.28214@chino.kir.corp.google.com> <alpine.DEB.2.00.1210171428540.20712@chino.kir.corp.google.com> <507F803A.8000900@jp.fujitsu.com>
 <507F86BD.7070201@jp.fujitsu.com> <alpine.DEB.2.00.1210181255470.26994@chino.kir.corp.google.com> <508110C4.6030805@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Kamezawa Hiroyuki wrote:

> From c5849c9034abeec3f26bf30dadccd393b0c5c25e Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 19 Oct 2012 17:00:55 +0900
> Subject: [PATCH] hold task->mempolicy while numa_maps scans.
> 
>  /proc/<pid>/numa_maps scans vma and show mempolicy under
>  mmap_sem. It sometimes accesses task->mempolicy which can
>  be freed without mmap_sem and numa_maps can show some
>  garbage while scanning.
> 
> This patch tries to take reference count of task->mempolicy at reading
> numa_maps before calling get_vma_policy(). By this, task->mempolicy
> will not be freed until numa_maps reaches its end.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good, but the patch is whitespace damaged so it doesn't apply.  When 
that's fixed:

Acked-by: David Rientjes <rientjes@google.com>

Thanks for following through on this!
