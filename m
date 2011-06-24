Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1FXLqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:46:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38185 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1FXLqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Zxggh4CZGloG15OopPKxN7/acmVTX4Sz8XgySuLMjSzwkohVKZxdp3ONODZHoN+ZXV
         tCI2xIv2SByAK9WlUNfbytWMCFGdwSrciWZVxM5GTa4vyOfTu05KlC9e6DT7mcabqW0Z
         uTP00cP+/zJOX52PeHvRczwmU3MM5V8Jn7nv4=
MIME-Version: 1.0
In-Reply-To: <20110624075742.GA10455@tiehlicka.suse.cz>
References: <20110622120635.GB14343@tiehlicka.suse.cz>
	<20110622121516.GA28359@infradead.org>
	<20110622123204.GC14343@tiehlicka.suse.cz>
	<20110623150842.d13492cd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623074133.GA31593@tiehlicka.suse.cz>
	<20110623170811.16f4435f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623090204.GE31593@tiehlicka.suse.cz>
	<20110623190157.1bc8cbb9.kamezawa.hiroyu@jp.fujitsu.com>
	<20110624075742.GA10455@tiehlicka.suse.cz>
Date: Fri, 24 Jun 2011 20:46:29 +0900
Message-ID: <BANLkTin7TbK1dNjPG6jz_FaJy-QgOjDJaA@mail.gmail.com>
Subject: Re: [PATCH] mm: preallocate page before lock_page at filemap COW.
 (WasRe: [PATCH V2] mm: Do not keep page locked during page fault while
 charging it for memcg
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Lutz Vieweg <lvml@5t9.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/24 Michal Hocko <mhocko@suse.cz>:
> Sorry, forgot to send my
> Reviewed-by: Michal Hocko <mhocko@suse>
>

Thanks.

> I still have concerns about this way to handle the issue. See the follow
> up discussion in other thread (https://lkml.org/lkml/2011/6/23/135).
>
> Anyway I think that we do not have many other options to handle this.
> Either we unlock, charge, lock&restes or we preallocate, fault in
>
I agree.

> Or am I missing some other ways how to do it? What do others think about
> these approaches?
>

Yes, I'd like to hear other mm specialists' suggestion. and I'll think
other way, again.
Anyway, memory reclaim with holding a lock_page() can cause big latency
or starvation especially when memcg is used. It's better to avoid it.

Thanks,
-Kame
