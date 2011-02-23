Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1BWD0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:26:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:53837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1BWD0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:26:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,210,1297065600"; 
   d="scan'208";a="712046277"
Subject: Re: more dput lock contentions in 2.6.38-rc?
From: Shaohua Li <shaohua.li@intel.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <1295919258.1949.973.camel@sli10-conroe>
References: <1295915725.1949.967.camel@sli10-conroe>
	 <AANLkTikOdiQR+rWXzoU9z5sJv9Q2=ehdhi1NCHXT0a-w@mail.gmail.com>
	 <1295917864.1949.970.camel@sli10-conroe>
	 <AANLkTimwSNsjR5PnVP8JvzwEBwy3VtDp4DvNecKsTnxJ@mail.gmail.com>
	 <1295919258.1949.973.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 11:26:12 +0800
Message-ID: <1298431572.19589.1.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 09:34 +0800, Shaohua Li wrote:
> On Tue, 2011-01-25 at 09:26 +0800, Nick Piggin wrote:
> > On Tue, Jan 25, 2011 at 12:11 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > > On Tue, 2011-01-25 at 09:04 +0800, Nick Piggin wrote:
> > >> On Tue, Jan 25, 2011 at 11:35 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > >> > Hi,
> > >> > we are testing dbench benchmark and see big drop of 2.6.38-rc compared
> > >> > to 2.6.37 in several machines with 2 sockets or 4 sockets. We have 12
> > >> > disks mount to /mnt/stp/dbenchdata/sd*/ and dbench runs against data of
> > >> > the disks. According to perf, we saw more lock contentions:
> > >> > In 2.6.37: 13.00%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
> > >> > In 2.6.38-rc: 69.45%        dbench  [kernel.kallsyms]   [k]_raw_spin_lock
> > >> > -     69.45%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
> > >> >   - _raw_spin_lock
> > >> >      - 48.41% dput
> > >> >         - 61.17% path_put
> > >> >            - 60.47% do_path_lookup
> > >> >               + 53.18% user_path_at
> > >> >               + 42.13% do_filp_open
> > >> >               + 4.69% user_path_parent
> > >>
> > >> What filesystems are mounted on the path?
> > > ext3 or ext4
> > 
> > ext3 or 4 along every step of the path? Are there
> > any acls loaded, or security policy running?
> all disks are formated with the same fs, just some machines use ext3 and
> others ext4. no we don't have acl or security policy.
> > It may be possible that they're all coming from
> > /proc/ access.
> I added trace in dput just after the lock taken. and most files are '/',
> 'mnt', 'stp'. the percentage of 'proc' is small actually.
Hi Nick,
Anything I can test for this issue?

Thanks,
Shaohua


