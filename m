Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0KUQfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:35:06 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40929 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0KUQfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=A68/Q0EK+VMHqsHGc0O/at01MrMq822SIcyiWh0jpVwIizPg+O2eVhvfcux7DIgvKt
         euh9it2HoXGO4FbonBIbtEtT7HXa4acuX0Wdjun9S/hX+4bln7SyZsU3LQlo1QheqcFX
         Vjosj67s0+JSwnGy57oq64S6jzcKplfHTjZOw=
From: Ben Gamari <bgamari@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 2/2] Prevent promotion of page in madvise_dontneed
In-Reply-To: <5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com> <5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 21 Nov 2010 11:34:57 -0500
Message-ID: <87tyjavdn2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 23:30:24 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
> Now zap_pte_range alwayas promotes pages which are pte_young &&
> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
> it's unnecessary since the page wouldn't use any more.
> 
Is this not against master? If it is, I think you might have forgotten
to update the zap_page_range() reference on mm/memory.c:1226 (in
zap_vma_ptes()). Should promote be true or false in this case? Cheers,

- Ben
