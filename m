Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0JUO4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:56:35 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36414 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751825Ab0JUO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:56:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _ohTirQVM1l.q9ucO5N6u6T6ywfgRI0gQVPebuJwP66K4PK
 91R9Mk7giCPxDOyF9vz4qeGiRcSzl5Rhws8yJvP5GzIDtrKB_2MOl6qp4JkU
 v0WI_U3VPUfxrcTaG.llsYPMJGm3g9blftrBgmgQ.gGgYyoftizZkB0DodRp
 s8vkvtoRqhzuQgmhvXPqPBg10Zna09xdxYDbjneWujCXbIPgL1o5bWMefiyH
 XoPfLllDRNigwjwiEFhL9dfFZcWEA
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Oct 2010 09:56:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <alpine.DEB.2.00.1010150206190.8103@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1010210948170.24115@router.home>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <20101014011056.a58bac55.akpm@linux-foundation.org> <alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com> <20101014153223.a710d70c.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1010150206190.8103@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, David Rientjes wrote:

> > hm.  It'd be better to make all the drivers depend on ZONE_DMA.  Good
> > luck with that :)
> >
>
> If they all truly depended on it then we'd never have been able to disable
> it.  I think breaking the build when you have CONFIG_ZONE_DMA=n and
> something is passing GFP_DMA would be the best alternative.

Yes I also think that is best. Forces the issues to be finally addressed.

Building without CONFIG_ZONE_DMA will remove the need to keep dma kmalloc
caches around and avoid checking for __GFP_DMA in the hotpaths of the slab
allocators.
