Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab2AYSyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:54:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64141 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2AYSyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:54:08 -0500
MIME-Version: 1.0
In-Reply-To: <20120124084133.GD1660@cmpxchg.org>
References: <20120119161445.b3a8a9d2.kamezawa.hiroyu@jp.fujitsu.com>
	<CALWz4ixufzgi2kDRgTMAzty-S2AKMmPfqdGc1sBRNFJxf-WTAQ@mail.gmail.com>
	<20120124084133.GD1660@cmpxchg.org>
Date: Wed, 25 Jan 2012 10:54:06 -0800
Message-ID: <CALWz4iyoRCFG9=aiySFzQb3HsM33yW7tZB4N6xee6qUvO6L2-g@mail.gmail.com>
Subject: Re: [PATCH] memcg: remove unnecessary thp check at page stat accounting
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:41 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Jan 23, 2012 at 12:11:11PM -0800, Ying Han wrote:
>> On Wed, Jan 18, 2012 at 11:14 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > Thank you very much for reviewing previous RFC series.
>> > This is a patch against memcg-devel and linux-next (can by applied without HUNKs).
>> >
>> > ==
>> >
>> > From 64641b360839b029bb353fbd95f7554cc806ed05 Mon Sep 17 00:00:00 2001
>> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Date: Thu, 12 Jan 2012 16:08:33 +0900
>> > Subject: [PATCH] memcg: remove unnecessary thp check in mem_cgroup_update_page_stat()
>> >
>> > commit 58b318ecf(memcg-devel)
>> >    memcg: make mem_cgroup_split_huge_fixup() more efficient
>> > removes move_lock_page_cgroup() in thp-split path.
>> >
>> > So, We do not have to check PageTransHuge in mem_cgroup_update_page_stat
>> > and fallback into the locked accounting because both move charge and thp
>> > split up are done with compound_lock so they cannot race. update vs.
>> > move is protected by the mem_cgroup_stealed sufficiently.
>>
>> Sorry, i don't see we changed the "move charge" to "move account" ?
>
> move_account() moves charges.  IMO, it's the function that is a
> misnomer and "moving charges" is less ambiguous since we account
> several different things in the memory controller.

Hmm, that works then.

Acked-by: Ying Han<yinghan@google.com>

--Ying
