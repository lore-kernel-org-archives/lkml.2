Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2JPEiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:38:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2JPEiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:38:08 -0400
Date: Mon, 15 Oct 2012 21:40:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] make GFP_NOTRACK flag unconditional
Message-Id: <20121015214040.4ef190eb.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1210152102220.5400@chino.kir.corp.google.com>
References: <1348826194-21781-1-git-send-email-glommer@parallels.com>
	<alpine.DEB.2.00.1210022156450.8723@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1210152102220.5400@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 21:02:45 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 2 Oct 2012, David Rientjes wrote:
> 
> > > There was a general sentiment in a recent discussion (See
> > > https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
> > > defined unconditionally. Currently, the only offender is GFP_NOTRACK,
> > > which is conditional to KMEMCHECK.
> > > 
> > > This simple patch makes it unconditional.
> > > 
> > > Signed-off-by: Glauber Costa <glommer@parallels.com>
> > > CC: Christoph Lameter <cl@linux.com>
> > > CC: Mel Gorman <mgorman@suse.de>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> > I think it was done this way to show that if CONFIG_KMEMCHECK=n then the 
> > bit could be reused for something else but I can't think of any reason why 
> > that would be useful; what would need to add a gfp bit that would also 
> > happen to depend on CONFIG_KMEMCHECK=n?  Nothing comes to mind to save a 
> > bit.
> > 
> > There are other cases of this as well, like __GFP_OTHER_NODE which is only 
> > useful for thp and it's defined unconditionally.  So this seems fine to 
> > me.
> > 
> 
> Still missing from linux-next as of this morning, I think this patch 
> should be merged.

It's in 3.7-rc1.

commit 3e648ebe076390018c317881d7d926f24d7bac6b
Author: Glauber Costa <glommer@parallels.com>
Date:   Mon Oct 8 16:33:52 2012 -0700

    make GFP_NOTRACK definition unconditional

