Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0KVELN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 23:11:13 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34835 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab0KVELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 23:11:12 -0500
Date: Mon, 22 Nov 2010 13:09:54 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [BUGFIX][PATCH] pagemap: set pagemap walk limit to PMD boundary
Message-ID: <20101122040953.GB3017@spritzera.linux.bs1.fc.nec.co.jp>
References: <1290157665-17215-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20101122120102.e0e76373.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20101122120102.e0e76373.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -776,7 +777,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
> >  		unsigned long end;
> >
> >  		pm.pos = 0;
> > -		end = start_vaddr + PAGEMAP_WALK_SIZE;
> > +		end = (start_vaddr + PAGEMAP_WALK_SIZE) & PAGEMAP_WALK_MASK;
> >  		/* overflow ? */
> >  		if (end < start_vaddr || end > end_vaddr)
> >  			end = end_vaddr;
>
> Ack.
>
> But ALIGN() can't be used ?

ALIGN() returns the same address as the input if it is already aligned,
but what we need here is the next PMD boundary. So something like

                end = IS_ALIGNED(start_vaddr, PAGEMAP_WALK_SIZE) ?
                        start_vaddr + PAGEMAP_WALK_SIZE :
                        ALIGN(start_vaddr, PAGEMAP_WALK_SIZE)          

keeps the semantics, but I don't like it because it's lengthy.

Anyway, thanks for your comment.

Naoya Horiguchi
