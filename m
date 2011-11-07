Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928Ab1KGFIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:08:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:35984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1KGFIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:08:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,468,1315206000"; 
   d="scan'208";a="81848016"
Subject: Re: [patch 1/5]thp: improve the error code path
From: Shaohua Li <shaohua.li@intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1319593680.22361.145.camel@sli10-conroe>
References: <1319511521.22361.135.camel@sli10-conroe>
	 <20111025114406.GC10182@redhat.com>
	 <1319593680.22361.145.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 13:17:29 +0800
Message-ID: <1320643049.22361.204.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 09:48 +0800, Shaohua Li wrote:
> On Tue, 2011-10-25 at 19:44 +0800, Andrea Arcangeli wrote:
> > Hello,
> > 
> > On Tue, Oct 25, 2011 at 10:58:41AM +0800, Shaohua Li wrote:
> > > +#ifdef CONFIG_SYSFS
> > > +	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
> > > +remove_hp_group:
> > > +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> > > +delete_obj:
> > > +	kobject_put(hugepage_kobj);
> > >  out:
> > > +#endif
> > 
> > Adding an ifdef is making the code worse, the whole point of having
> > these functions become noops at build time is to avoid having to add
> > ifdefs in the callers.
> yes, but hugepage_attr_group is defined in CONFIG_SYSFS. And the
> functions are inline functions. They really should be a '#define xxx'.
ping, any comments for the 5 patches?

