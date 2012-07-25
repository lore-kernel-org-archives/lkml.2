Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab2GYRN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:13:29 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:29770 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750961Ab2GYRN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:13:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rzg1zs4VM1kEcmr1SbAjMhLpqb_U7wdt358ppfFsW7ao1qF
 peVYMKAYR3M3H0GsmYa5N4hxZj8iBqXzZ6dQsjab9xjWWloXBk0EEpVrcnPE
 IIy4UONQAYfnq_rlrm5oypGXzb.HoNeNGEjvjvmywT25KeBAmO4VRtilg_S1
 kQoR27wa9Yg8rnA0vBExL5btO.rEtVq1QZ3zNXjuLkfQJkLaUq9wBM9ni1iz
 sd0J1NVDWxc9UrI04Bnigp_3pZ.QnIlX7idFPN0uluw195411Dv0JEsnb4S.
 L_tlv72NfOUYsVTOENanYIveB.Q.VOnnq1pTluOwvrlrw02NaY0AOBRS5vck
 LBUitWmVSeH.d6q351TPhj_lyfpzPVqZb1VYvm139Cn9gI4XpNVNLx_5BoZ7
 TMAIoNzVDDFZ_VuFP
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 12:13:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        cgroups@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 10/10] memcg/sl[au]b: shrink dead caches
In-Reply-To: <1343227101-14217-11-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1207251207180.3543@router.home>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-11-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Glauber Costa wrote:

> In the slub allocator, when the last object of a page goes away, we
> don't necessarily free it - there is not necessarily a test for empty
> page in any slab_free path.

That is true for the slab allocator as well. In either case calling
kmem_cache_shrink() will make the objects go away by draining the cached
objects and freeing the pages used for the objects back to the page
allocator. You do not need this patch. Just call the proper functions to
drop the objecgts in the caches in either allocator.

> The slab allocator has a time based reaper that would eventually get rid
> of the objects, but we can also call it explicitly, since dead caches
> are not a likely event.

So this is already for both allocators?
