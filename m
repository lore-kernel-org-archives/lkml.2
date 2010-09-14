Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0INRrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:47:15 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:26477 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754472Ab0INRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:47:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ZTjaDrwVM1mj1LTdDrb.J3oWsNfAkD2hEvNjmcYe3FkByil
 1ET5vb1_9WShP5IqgmwvAClm9VS5R.TpccWE89lsX5C2MY7ffYXSSl49S5Gr
 bWpRtYK.cr_X63jf94_Q8gKBaMs1HZCurzMmPyYqoh.d6fpuEUC_ELPBCFqE
 AS0k7Ctq.6uLuXeFKBc9LjHPzTHwUCSBl5Neg7q8ZcfBYtF3cUKVqx1nCdxR
 G
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Sep 2010 12:47:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: torvalds@linux-founation.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] SLUB: Fix merged slab cache names
In-Reply-To: <4C8FB2AC.1030107@kernel.org>
Message-ID: <alpine.DEB.2.00.1009141244330.444@router.home>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141221310.31857@router.home> <4C8FB2AC.1030107@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:

> > Put this into mm/slub.c as slub only flag? What is the difference from
> > refcount == 1?
> I can put it in mm/slub.c but I was worried about someone reusing the bit for
> something else.

Allocate from the other end like __OBJECT_POISON.

> Do you mean refcount == 2? You don't know during kmem cache release time if
> someone was merged to the cache or not.

> > Ok. Keeping the original name. Why dont we do strdup by default and always
> > do a kfree(s->name) on close?
> >
> I tried that. It gets very nasty during bootstrap.

Add it only to kmem_cache_create() not to kmem_cache_open. That is not
used during bootstrap. The bootstrap caches do not matter since they are
never freed.
