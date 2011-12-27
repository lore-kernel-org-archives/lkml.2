Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1L0Xve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:51:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1L0Xvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:51:33 -0500
Date: Tue, 27 Dec 2011 15:51:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
Message-Id: <20111227155132.d64fd6d8.akpm@linux-foundation.org>
In-Reply-To: <20111227125701.GG5344@tiehlicka.suse.cz>
References: <CAJd=RBCS3-PoFa3FUVwhiznPTQH5xq7fTYa3m01a0-buACQbCA@mail.gmail.com>
	<20111227125701.GG5344@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 13:57:01 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Fri 23-12-11 21:38:38, Hillf Danton wrote:
> > From: Hillf Danton <dhillf@gmail.com>
> > Subject: [PATCH] mm: hugetlb: avoid bogus counter of surplus huge page
> > 
> > If we have to hand back the newly allocated huge page to page allocator,
> > for any reason, the changed counter should be recovered.
> > 
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Broken since 2.6.27 (caff3a2c: hugetlb: call arch_prepare_hugepage() for
> surplus pages) so a stable material

afacit only s390 is affected, and s390's page_table_alloc() is fairly
immortal, using GFP_KERNEL|__GFP_REPEAT.

So unless Martin and Heiko disagree, I think we can merge this in 3.3-rc1.
