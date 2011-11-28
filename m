Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1K1HDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:03:34 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab1K1HDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
Date: Mon, 28 Nov 2011 12:33:31 +0530
Message-ID: <CAKTCnz=CObdw0z4Qf36=afwwApuTer5C4Jp21QUko-H__q-+aA@mail.gmail.com>
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never returns NULL
From: Balbir Singh <bsingharora@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> From: Johannes Weiner <jweiner@redhat.com>
>
> Pages have their corresponding page_cgroup descriptors set up before
> they are used in userspace, and thus managed by a memory cgroup.
>
> The only time where lookup_page_cgroup() can return NULL is in the
> page sanity checking code that executes while feeding pages into the
> page allocator for the first time.
>

This is a legacy check from the days when we allocated PC during fault
time on demand. It might make sense to assert on !pc in DEBUG_VM mode
at some point in the future

Balbir
