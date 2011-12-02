Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1LBUCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:02:32 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:24018 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753380Ab1LBUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:02:31 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kFFweSEVM1lkrqVUcim.akpxpvB3NvTyFYhF_4qa9.UUacL
 KAlMzEom4nElxgqSymp_xo2Egg2T1yGPD6xC_Qy96.ngTbO2D3xs27syxyrX
 hjihPenvPkgeT3GGLhUGHBFMGhQehRBFN5yQLMzSwKHYS5ApCQGqGUhG0Wc0
 NF91hhP7I63tY7dwd1bXMjB2YJ4B0t9vGhkwBQ3LCadw_l8gxQnJ5tXyS6mN
 izQA556avYXbHobTyVK_0UC2dtEO_YLMnB0ZqkCoB9L7lRv_WmiLSpVX43xA
 wELiHBk5PUaBVXDBBxNb_AHWyGYeT9ElWqyglvVuWgjheJC.Gi2tX.IBzk6h
 CagnHxK1YlR9k0OPh_yxGjX3OATiHT4OnbapFBTHcuomM8w--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Dec 2011 14:02:28 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Alex Shi <alex.shi@intel.com>, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1322825802.2607.10.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1112021401200.13405@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <1322825802.2607.10.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Eric Dumazet wrote:

> netperf (loopback or ethernet) is a known stress test for slub, and your
> patch removes code that might hurt netperf, but benefit real workload.
>
> Have you tried instead this far less intrusive solution ?
>
> if (tail == DEACTIVATE_TO_TAIL ||
>     page->inuse > page->objects / 4)
>          list_add_tail(&page->lru, &n->partial);
> else
>          list_add(&page->lru, &n->partial);

One could also move this logic to reside outside of the call to
add_partial(). This is called mostly from __slab_free() so the logic could
be put in there.

