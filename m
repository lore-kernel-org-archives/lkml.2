Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1LNO73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:59:29 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:43554 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755159Ab1LNO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:59:28 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3OHMuMIVM1nIdUgKZxj8kXeREZmASBn_bB0B9D93PnF0XgS
 uQy4875_JqOnRL.FjcTv1cJKfyaaY1VAsa.fiQE0AFTA5kG81K8nF.WyFgGy
 8IdGbKbn1oI9Uw9biyjYQd7ayGcv381.QGB_h3hcopICFQjdXjkqw.w0v83w
 Ku1sWn1OCqKwXj7HhVVuqZCMWyw.7H.vuVS67biTukOg0xpfx.DRvXB_xCF0
 AKMYe6j81J4MSgKkYp_2_1reslAZM_LrxUp7GgySZ5UHD83YKcIEz_CaX9oi
 E5L9SwU4G_xECkngg0PKIBhM4UiZELFavVd_NQzLFoAKSPgg46Tj4kWHCmYa
 b.NoHegXWanKmXffYFUzCSn6cZNCoxJHMlNtBJDASsVHZ.QP5jvRi0LhMP7n
 NKcCCTBaDs._NKLohYNJ._g--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 14 Dec 2011 08:59:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323845812.16790.8307.camel@debian>
Message-ID: <alpine.DEB.2.00.1112140853540.12235@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.00.1112020842280.10975@router.home>  <1323419402.16790.6105.camel@debian>  <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>  <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>  <1323842761.16790.8295.camel@debian> 
 <1323845054.2846.18.camel@edumazet-laptop> <1323845812.16790.8307.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Alex,Shi wrote:

> > Please note that the COLD/HOT page concept is not very well used in
> > kernel, because its not really obvious that some decisions are always
> > good (or maybe this is not well known)
>
> Hope Christoph know everything of SLUB. :)

Well yes we have been back and forth on hot/cold page things repeatedly in
the page allocator as well. Caching is not always good. There are
particular loads that usually do very well with caching. Others do not.
Caching can cause useless processing and pollute caching. It is also a
cause for OS noise due to cache maintenance at random (for the app guys)
times where they do not want that to happen.

> > We should try to batch things a bit, instead of doing a very small unit
> > of work in slow path.
> >
> > We now have a very fast fastpath, but inefficient slow path.
> >
> > SLAB has a litle cache per cpu, we could add one to SLUB for freed
> > objects, not belonging to current slab. This could avoid all these
> > activate/deactivate overhead.
>
> Maybe worth to try or maybe Christoph had studied this?

Many people have done patchsets like this. There are various permutations
on SL?B (I dont remember them all SLEB, SLXB, SLQB etc) that have been
proposed over the years. Caches tend to grow and get rather numerous (see
SLAB) and the design of SLUB was to counter that. There is a reason it was
called SLUB. The U stands for Unqueued and was intended to avoid the
excessive caching problems that I ended up when reworking SLAB for NUMA
support.
