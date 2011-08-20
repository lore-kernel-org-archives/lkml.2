Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1HTP6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 11:58:53 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22490 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753319Ab1HTP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 11:58:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bUPd94YVM1keChsKE848ggfP8.hR1.H_sOrnnSv92aqcq.v
 _gvuOBoPDJcFRoQf.EE1kJUjKbTFTUYvPvX0dX9qTkHyXOA9oDIr.FqIVNj5
 BrdPhtCOdcx8m.RymImWcpc0rHx3r69nUrN.5b5Xs2L93RdhTqUTtK9QQ5oL
 GozD4eWfKwZ3sJZw.ggb9TWeB7yjZazhSZbm5bp6eDe58av5UbiLDx8STRVB
 oRffqDGQXvXFFxxzuN.dEOvQLz61o9xiXnYoUjMI_Do5W58SLILaaBEC8sKi
 zWwHXU1HAuDym9yIyEzCHkNU6F5QCkmF1nzdLizhm3XAlTeuc76goOjMFzrU
 Ulmm_U.DVXLl3PRsbuRMcGBMv9HzmO0ne.stJGoro6HnzeQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Sat, 20 Aug 2011 10:58:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [slub p4 1/7] slub: free slabs without holding locks (V2)
In-Reply-To: <alpine.DEB.2.00.1108201331400.3008@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1108201056070.5267@router.home>
References: <20110809211221.831975979@linux.com> <20110809211259.123603907@linux.com> <alpine.DEB.2.00.1108201331400.3008@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011, Pekka Enberg wrote:

> > static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
> > {
>
> Is it possible to somehow verify that we're the last thread using the cache
> when SLUB debugging is enabled? It'd be useful for tracking down callers that
> violate this assumption.

Hmmm... We do not track "threads" using slabs. I do not really know what
the "thread" entity that would access a slab is? A subsystem? A kernel
thread? A user thread? All these can access any slab at any time.

