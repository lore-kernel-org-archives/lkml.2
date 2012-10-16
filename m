Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2JPECu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:02:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56973 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2JPECs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:02:48 -0400
Date: Mon, 15 Oct 2012 21:02:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] make GFP_NOTRACK flag unconditional
In-Reply-To: <alpine.DEB.2.00.1210022156450.8723@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1210152102220.5400@chino.kir.corp.google.com>
References: <1348826194-21781-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210022156450.8723@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, David Rientjes wrote:

> > There was a general sentiment in a recent discussion (See
> > https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
> > defined unconditionally. Currently, the only offender is GFP_NOTRACK,
> > which is conditional to KMEMCHECK.
> > 
> > This simple patch makes it unconditional.
> > 
> > Signed-off-by: Glauber Costa <glommer@parallels.com>
> > CC: Christoph Lameter <cl@linux.com>
> > CC: Mel Gorman <mgorman@suse.de>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> I think it was done this way to show that if CONFIG_KMEMCHECK=n then the 
> bit could be reused for something else but I can't think of any reason why 
> that would be useful; what would need to add a gfp bit that would also 
> happen to depend on CONFIG_KMEMCHECK=n?  Nothing comes to mind to save a 
> bit.
> 
> There are other cases of this as well, like __GFP_OTHER_NODE which is only 
> useful for thp and it's defined unconditionally.  So this seems fine to 
> me.
> 

Still missing from linux-next as of this morning, I think this patch 
should be merged.
