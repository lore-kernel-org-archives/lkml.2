Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab1JXSSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:18:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40938 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab1JXSSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:18:53 -0400
Date: Mon, 24 Oct 2011 14:18:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include two
 overrides for TTM page pool.
Message-ID: <20111024181806.GA4369@phenom.dumpdata.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
 <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com>
 <4EA28FA6.7000006@shipmail.org>
 <20111024172728.GD2320@phenom.dumpdata.com>
 <4EA5A381.1050100@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA5A381.1050100@shipmail.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EA5ABE8.0146:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >For that there are couple of architectural issues I am not sure how to solve.
> >
> >There has to be some form of TTM<->[Radeon|Nouveau] lookup mechanism
> >to say: "here is a 'struct page *', give me the bus address". Currently
> >this is solved by keeping an array of DMA addresses along with the list
> >of pages. And passing the list and DMA address up the stack (and down)
> >from TTM up to the driver (when ttm->be->func->populate is called and they
> >are handed off) does it. It does not break any API layering .. and the internal
> >TTM pool (non-DMA) can just ignore the dma_address altogether (see patch above).
> >
> 
> I actually had something more simple in mind, but when tinking a bit
> deeper into it, it seems more complicated than I initially thought.
> 
> Namely that when we allocate pages from the ttm_backend, we actually
> populated it at the same time. be::populate would then not take a
> page array as an argument, and would actually be a no-op on many
> drivers.

The programming of the gfx's MMU.. would be done via a new API call?
I think this needs a bit of whiteboarding for me to be sure I understand you.
> 
> This makes us move towards struct ttm_tt consisting almost only of
> its backend, so that whole API should perhaps be looked at with new
> eyes.
> 
> So anyway, I'm fine with high level things as they are now, and the

Great!
> dma_addr issue can be looked at at a later time. If we could get a
> couple of extra eyes to review the code for style etc. would be

Anybody in particular you can recommend that I can pester^H^H^H^H politely
ask :-)

> great, because I have very little time the next couple of weeks.

<nods> Understood. 
