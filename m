Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1AGUet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:34:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1AGUer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=k1dfaagL1RxLvVBwhe5+3YR+6Xab1KEtqvhI9qTnfvlNV8gar3GcE/UyrziQNHXsHl
         KI6AH6WBwSsjR600p8sg==
Date: Fri, 7 Jan 2011 12:34:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <alpine.DEB.2.00.1101070922100.3014@router.home>
Message-ID: <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com> <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101061107500.8655@router.home> <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1101070922100.3014@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Christoph Lameter wrote:

> Subject: slub: Avoid use of slub_lock in show_slab_objects()
> 
> The purpose of the locking is to prevent removal and additions
> of nodes when statistics are gathered for a slab cache. So we
> need to avoid racing with memory hotplug functionality.
> 
> It is enough to take the memory hotplug locks there instead
> of the slub_lock.
> 

Because memory hotplug is the only time s->node[] is modified after the 
sysfs files are created, which is the only time show_slab_objects() is 
called.

> online_pages() does not acquire the memory_hotplug lock. So
> add the missing locking there.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>

 [ Should probably be seperated out into two patches, one for the
   memory hotplug locking addition and one for the slub fix, both
   should be pushed during this merge window.  If so, a comment
   describing the new semantics of lock_memory_hotplug() to protect 
   data structures that may be modified in hotplug notifier 
   callbacks would be appreciated. ]
