Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2E2Qts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:49:48 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:33575 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754200Ab2E2Qtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:49:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _KDeAu0VM1liWAxWY4IRaWEp7txi40OtGu.A7EQ.OCuGqqu
 USfTW7GhQ7sGZ4VwNQY5Av_aeoWCH6yzeT7.S.IEJ8D2fqchRFd_jtKO5cvO
 sGPSY4FWUTx0RsKeOdYyGmEIYESHnrMIIfSSA9vOpFFXdK8vRsbkgmwgbmrt
 kt.UeVJuMbEpJjIC9iUlohXQ06nQ32hHO9g67RPU7_tkBxzPssicsWGjFDNh
 K1O6j2BnJkxxmItIW.8oOZG_h5wCh8XlJoSSXsj84dyCpQFqWKHabEGeGIRS
 nRgm4E_HW_kPeq26d4rsu4BE3gguLf6myzo0RN22.TCsW_Wv0KsyqTfwtbs2
 WwyuzZInTvhXhOn7mVLWup3783MNmWr_zHsCTiTVe2IQhl5SlHsTBijDmaCD
 l
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 11:05:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
In-Reply-To: <4FC4F1A7.2010206@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291101580.6723@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> Accounting pages seems just crazy to me. If new allocators come in the future,
> organizing the pages in a different way, instead of patching it here and
> there, we need to totally rewrite this.

Quite to the contrary. We could either pass a THIS_IS_A_SLAB page flag to
the page allocator call or have a special call that does the accounting
and then calls the page allocator. The code could be completely in
cgroups. There would be no changes to the allocators aside from setting
the flag or calling the alternate page allocator functions.

> > Why do you need to increase the refcount? You made a full copy right?
>
> Yes, but I don't want this copy to go away while we have other caches around.

You copied all metadata so what is there that you would still need should
the other copy go away?

> So, in the memcg internals, I used a different reference counter, to avoid
> messing with this one. I could use that, and leave the original refcnt alone.
> Would you prefer this?

The refcounter is really not the issue.

I am a bit worried about the various duplicate features here and there.
The approach is not tightened down yet.

