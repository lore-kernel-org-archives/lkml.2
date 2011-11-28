Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1K1JRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:17:15 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60336 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1K1JRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:17:14 -0500
Date: Mon, 28 Nov 2011 10:17:03 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never returns
 NULL
Message-ID: <20111128091703.GB9356@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
 <CAKTCnz=CObdw0z4Qf36=afwwApuTer5C4Jp21QUko-H__q-+aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnz=CObdw0z4Qf36=afwwApuTer5C4Jp21QUko-H__q-+aA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 12:33:31PM +0530, Balbir Singh wrote:
> On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > From: Johannes Weiner <jweiner@redhat.com>
> >
> > Pages have their corresponding page_cgroup descriptors set up before
> > they are used in userspace, and thus managed by a memory cgroup.
> >
> > The only time where lookup_page_cgroup() can return NULL is in the
> > page sanity checking code that executes while feeding pages into the
> > page allocator for the first time.
> >
> 
> This is a legacy check from the days when we allocated PC during fault
> time on demand. It might make sense to assert on !pc in DEBUG_VM mode
> at some point in the future

I don't think a BUG_ON bears more information than a null-pointer
dereference.
