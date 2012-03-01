Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2CABVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:21:48 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40198 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2CABVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:21:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.72.138 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Wed, 29 Feb 2012 17:21:18 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH next] memcg: remove PCG_CACHE page_cgroup flag fix
In-Reply-To: <20120229194304.GF1673@cmpxchg.org>
Message-ID: <alpine.LSU.2.00.1202291718450.11821@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils> <alpine.LSU.2.00.1202282128500.4875@eggly.anvils> <20120229194304.GF1673@cmpxchg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Johannes Weiner wrote:
> On Tue, Feb 28, 2012 at 09:30:17PM -0800, Hugh Dickins wrote:
> >  
> > +	anon = PageAnon(page);
> > +
> >  	switch (ctype) {
> >  	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> > +		anon = true;
> > +		/* fallthrough */
> 
> If you don't mind, could you add a small comment on why this is the
> exception where we don't trust page->mapping?

Right, I'll send an incremental fix for that.

> 
> Other than that,
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks,
Hugh
