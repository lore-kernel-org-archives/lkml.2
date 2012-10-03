Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2JCFAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:00:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2JCFAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:00:22 -0400
Date: Tue, 2 Oct 2012 22:00:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] make GFP_NOTRACK flag unconditional
In-Reply-To: <1348826194-21781-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1210022156450.8723@chino.kir.corp.google.com>
References: <1348826194-21781-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Glauber Costa wrote:

> There was a general sentiment in a recent discussion (See
> https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
> defined unconditionally. Currently, the only offender is GFP_NOTRACK,
> which is conditional to KMEMCHECK.
> 
> This simple patch makes it unconditional.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Mel Gorman <mgorman@suse.de>
> CC: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>

I think it was done this way to show that if CONFIG_KMEMCHECK=n then the 
bit could be reused for something else but I can't think of any reason why 
that would be useful; what would need to add a gfp bit that would also 
happen to depend on CONFIG_KMEMCHECK=n?  Nothing comes to mind to save a 
bit.

There are other cases of this as well, like __GFP_OTHER_NODE which is only 
useful for thp and it's defined unconditionally.  So this seems fine to 
me.
