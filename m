Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2EVWbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:31:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43300 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2EVWbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:31:48 -0400
Date: Tue, 22 May 2012 15:31:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
In-Reply-To: <alpine.DEB.2.00.1205221216050.17721@router.home>
Message-ID: <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com>
 <alpine.DEB.2.00.1205221216050.17721@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Christoph Lameter wrote:

> > I think that's precisely David's point: that we might want to destroy them
> > eventually.
> 
> Cannot imagine why.
> 

We can't predict how slab will be extended in the future and this affects 
anything created before g_cpucache_cpu <= EARLY.  This would introduce the 
first problem with destroying such caches and is unnecessary if a 
workaround exists.
