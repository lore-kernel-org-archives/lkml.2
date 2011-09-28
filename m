Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1I1OFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:05:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36739 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1I1OFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:05:18 -0400
MIME-Version: 1.0
Message-ID: <1a2c1697-9ed6-4cb8-8da9-d252045b8a75@default>
Date: Wed, 28 Sep 2011 07:03:52 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com,
        levinsasha928@gmail.com
Subject: RE: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap
 feedback
References: <20110915213446.GA26406@ca-server1.us.oracle.com
 20110928150841.fbe661fe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110928150841.fbe661fe.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E83296D.01E0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap feedback
> 
> On Thu, 15 Sep 2011 14:34:46 -0700
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Subject: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap feedback
> 	err = sysfs_create_group(mm_kobj, &cleancache_attr_group);
> > -#endif /* CONFIG_SYSFS */
> > +#ifdef CONFIG_DEBUG_FS
> > +	struct dentry *root = debugfs_create_dir("cleancache", NULL);
> > +	if (root == NULL)
> > +		return -ENXIO;
> > +	debugfs_create_u64("succ_gets", S_IRUGO, root, &cleancache_succ_gets);
> > +	debugfs_create_u64("failed_gets", S_IRUGO,
> > +				root, &cleancache_failed_gets);
> > +	debugfs_create_u64("puts", S_IRUGO, root, &cleancache_puts);
> > +	debugfs_create_u64("invalidates", S_IRUGO,
> > +				root, &cleancache_invalidates);
> > +#endif

Hi Kame --

Thanks for the review!

> No exisiting userlands are affected by this change of flush->invalidates ?

Not that I'm aware of.  As required by Andrew Morton, the frontswap
patchset now exposes ALL statistics through debugfs instead of sysfs.
For consistency, all cleancache statistics are also moved from sysfs
into debugfs, so this is a good time to also do the name change.
(The name change was also required by Andrew Morton, and previously
suggested by Minchan Kim.)

Thanks,
Dan
