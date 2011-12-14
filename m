Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1LNCiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:38:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36896 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1LNCio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:38:44 -0500
Date: Tue, 13 Dec 2011 18:38:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: "Shi, Alex" <alex.shi@intel.com>, Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323830622.22361.407.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1112131837160.31514@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <alpine.DEB.2.00.1112020842280.10975@router.home> <1323076965.16790.670.camel@debian> <alpine.DEB.2.00.1112061259210.28251@chino.kir.corp.google.com> <1323234673.22361.372.camel@sli10-conroe>
 <alpine.DEB.2.00.1112062319010.21785@chino.kir.corp.google.com> <1323657793.22361.383.camel@sli10-conroe> <alpine.DEB.2.00.1112131726140.8593@chino.kir.corp.google.com> <1323830622.22361.407.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Shaohua Li wrote:

> if vast majority of allocation needs picking from partial list of node,
> the list_lock will have contention too. But I'd say avoiding the slab
> thrashing does increase fastpath.

Right, that's why my 2009 patchset would attempt to grab the partial slab 
with the highest number of free objects to a certain threshold before 
falling back to others and it improved performance somewhat.  This was 
with the per-node partial lists, however, and the slowpath has been 
significantly rewritten since then.
