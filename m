Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688Ab2EKSRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:17:49 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:27518 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932215Ab2EKSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:17:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aY9bqesVM1kXj74EswpzTG6aYMUWtMCULwpo7a8HLouzDsD
 t3ZXfoEqvpgVBgHxAOxA5kwrq2iY8ixQpWm.yWhg1iH2nftrPf.D.kzHVarE
 HWAf3J2eZsyAJpvvQMcSna4WQXAQVX3aZjmHYqR5mUJdhfTbxtsUBC6vgN3d
 7dG69KRD3AfmeKf8lxaGCktMZm.WxwI0xcsks9XpDFLUdw6DiUTKwgOhlyub
 xchYBcOWNcuSYnbqjYVB159tN0HhwuDRht7Y2N1zOYhAuDrWXDifl784FcjQ
 KU5piSvyAaWbe80qouI0aQBg1dpLJbDcX.hf.UKFsrPzoEnHMePvi8VcPx0c
 nZRiiB7a56y.sCwIQ59J42JY4v7tr5oIEKiGPB9HjO1OF56h3RXQl.lSyBmZ
 F
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 13:17:41 -0500 (CDT)
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
In-Reply-To: <4FAD566C.3000804@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111316540.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
 <4FAD566C.3000804@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> On 05/11/2012 03:06 PM, Christoph Lameter wrote:
> > On Fri, 11 May 2012, Glauber Costa wrote:
> >
> > > > Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
> > > > always passed the correct slab cache.
> > >
> > > Well, problem is , it isn't always passed the "correct" slab cache.
> > > At least not after this series, since we'll have child caches associated
> > > with
> > > the main cache.
> > >
> > > So we'll pass, for instance, kmem_cache_free(dentry_cache...), but will in
> > > fact free from the memcg copy of the dentry cache.
> >
> > Urg. But then please only do this for the MEMCG case and add a fat big
> > warning in kmem_cache_free.
>
> I can do that, of course.
> Another option if you don't oppose, is to add another field in the kmem_cache
> structure (I tried to keep them at a minimum),
> to record the parent cache we got created from.
>
> Then, it gets trivial to do the following:
>
> VM_BUG_ON(page->slab != s && page->slab != s->parent_cache);

Sounds ok but I need to catch up on what this whole memcg thing in slab
allocators should accomplish in order to say something definite.

