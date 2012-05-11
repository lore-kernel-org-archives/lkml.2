Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929Ab2EKTUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:20:43 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:21257 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760812Ab2EKTUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:20:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3q5r8wMVM1lJrneXmcizgcWxPnqQJJy4YXlFXWF5YJzbayF
 SLXYFT7nbUsAumJzb.9nritiPrUbrYUfJ9KjUEJ8mgrR7ZG3zlc5TOmaiHLg
 MFNjnOvTUAUDN3oZBON71MRfK8o81hJccaJQ9vEi.2Iv9vQBdBZdH3Zy_Aed
 P_hoUp_T_4FbYROpY8US0eydmrd_X.HJauxOxTlf5THUmCfDgnoGmfcXwNda
 LteSOmwVSoFfiAOvWOTbGsZiHFDaYB8bT8Gaa3ro.aZBsmQSi0KIgcFuAykD
 F7c.LJmsWX6FvvUORyrtWmkO88DbPSp9XQI_55F_lowIqetwkmQLsoKtN1DS
 iZA8rLYF7uGrITW4eEP6Mvxuhm4PrE_f7_Ge1nsqFoo2cJReq3mRoip17L9I
 n
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 14:20:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
In-Reply-To: <4FAD6449.2060201@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111418350.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
 <4FAD566C.3000804@parallels.com> <alpine.DEB.2.00.1205111316540.386@router.home> <4FAD585A.4070007@parallels.com> <alpine.DEB.2.00.1205111331010.386@router.home> <4FAD5DA2.70803@parallels.com> <alpine.DEB.2.00.1205111354540.386@router.home>
 <4FAD6169.8090409@parallels.com> <alpine.DEB.2.00.1205111407280.386@router.home> <4FAD6449.2060201@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> > I see that. But there are other subsystems from slab allocators that do
> > the same. There are also objects that may be used by multiple processes.
>
> This is also true for normal user pages. And then, we do what memcg does:
> first one to touch, gets accounted. I don't think deviating from the memcg
> behavior for user pages makes much sense here.
>
> A cache won't go away while it still have objects, even after the memcg is
> removed (it is marked as dead)

Ok so we will have some dead pages around that are then repatriated to
the / set?

> > Hmmm.. Would be better to have a hierachy there. /proc/slabinfo is more
> > legacy.
>
> I can take a look at that then. Assuming you agree with all the rest, is
> looking into that a pre-requisite for merging, or is something that can be
> deferred for a phase2 ? (We still don't do shrinkers, for instance, so this is
> sure to have a phase2)

Not a prerequisite for merging but note that I intend to rework the
allocators to extract common code so that they have the same sysfs
interface, error reporting and failure scenarios. We can at that time
also add support for /sys/kernel/slab to memcg. (/sys/memcg/<name>/slab/* ?)
