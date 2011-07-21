Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1GUIoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:44:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63705 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1GUIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:44:08 -0400
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
In-Reply-To: <alpine.DEB.2.00.1107200950270.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>
	 <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>
	 <alpine.DEB.2.00.1107200854390.32737@router.home>
	 <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1107200950270.1472@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 10:43:59 +0200
Message-ID: <1311237839.2422.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 juillet 2011 à 09:52 -0500, Christoph Lameter a écrit :

> We should be making it a per cpu pointer like slub then. I looked at what
> it would take to do so a couple of month ago but it was quite invasive.
> 

I took a look at this too, but using percpu data would consume more
memory, because percpu allocator allocates memory blobs for all possible
cpus, while current code handles online/offline cpu nicely.



