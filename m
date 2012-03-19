Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2CSHOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:14:24 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53631 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab2CSHOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:14:22 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 07/10] hugetlbfs: Add memcg control files for hugetlbfs
In-Reply-To: <4F66A059.20801@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A059.20801@jp.fujitsu.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Mar 2012 12:44:11 +0530
Message-ID: <87wr6hjc58.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031821-1618-0000-0000-00000118E3F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 11:56:25 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > This add control files for hugetlbfs in memcg
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> 
> I have a question. When a user does
> 
> 	1. create memory cgroup as
> 		/cgroup/A
> 	2. insmod hugetlb.ko
> 	3. ls /cgroup/A
> 
> and then, files can be shown ? Don't we have any problem at rmdir A ?
> 
> I'm sorry if hugetlb never be used as module.

HUGETLBFS cannot be build as kernel module


> 
> a comment below.
> 
> > ---
> >  include/linux/hugetlb.h    |   17 +++++++++++++++
> >  include/linux/memcontrol.h |    7 ++++++
> >  mm/hugetlb.c               |   25 ++++++++++++++++++++++-
> >  mm/memcontrol.c            |   48 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 96 insertions(+), 1 deletions(-)


......

> > 
> > +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> > +static char *mem_fmt(char *buf, unsigned long n)
> > +{
> > +	if (n >= (1UL << 30))
> > +		sprintf(buf, "%luGB", n >> 30);
> > +	else if (n >= (1UL << 20))
> > +		sprintf(buf, "%luMB", n >> 20);
> > +	else
> > +		sprintf(buf, "%luKB", n >> 10);
> > +	return buf;
> > +}
> > +
> > +int mem_cgroup_hugetlb_file_init(int idx)
> > +{
> 
> 
> __init ? 

Added .

>And... do we have guarantee that this function is called before
> creating root mem cgroup even if CONFIG_HUGETLBFS=y ?
> 

Yes. This should be called before creating root mem cgroup.

-aneesh

