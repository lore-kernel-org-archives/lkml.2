Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790Ab2CNKte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:49:34 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38263 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2CNKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:49:29 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 4/8] memcg: track resource index in cftype private
In-Reply-To: <4F5F4CD0.3080207@parallels.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F5F4CD0.3080207@parallels.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 16:18:44 +0530
Message-ID: <87obrz8nlf.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031400-1618-0000-0000-000001107563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 17:34:08 +0400, Glauber Costa <glommer@parallels.com> wrote:
> On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
> >   		if (type == _MEM)
> >   			ret = mem_cgroup_resize_limit(memcg, val);
> > -		else
> > +		else if (type == _MEMHUGETLB) {
> > +			int idx = MEMFILE_IDX(cft->private);
> > +			ret = res_counter_set_limit(&memcg->hugepage[idx], val);
> > +		} else
> >   			ret = mem_cgroup_resize_memsw_limit(memcg, val);
> >   		break;
> >   	case RES_SOFT_LIMIT:
> 
> What if a user try to set limit < usage ? Isn't there any reclaim that 
> we could possibly do, like it is done by normal memcg ?

No, HugeTLB doesn't support reclaim. If we set the limit to a value
below current usage, future allocations will fail, but we don't reclaim.


-aneesh

