Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1ATHxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:53:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:2740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1ATHxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:53:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,349,1291622400"; 
   d="scan'208";a="594735527"
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
From: "Alex,Shi" <alex.shi@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110119125630.GB4246@quack.suse.cz>
References: <1295402148.4773.143.camel@debian>
	 <1295402606.1949.871.camel@sli10-conroe>
	 <20110119125630.GB4246@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 15:52:52 +0800
Message-ID: <1295509972.4773.301.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 20:56 +0800, Jan Kara wrote:
> On Wed 19-01-11 10:03:26, Shaohua Li wrote:
> > add Jan and Theodore to the loop.
>   Thanks.
> 
> > On Wed, 2011-01-19 at 09:55 +0800, Shi, Alex wrote:
> > > Shaohua and I tested kernel building performance on latest kernel. and
> > > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > > system. We find this performance dropping is due to commit
> > > 749ef9f8423054e326f. If we revert this patch or just change the
> > > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
> > > recovered.
> > >
> > > iostat report show with the commit, read request merge number increased
> > > and write request merge dropped. The total request size increased and
> > > queue length dropped. So we tested another patch: only change WRITE_SYNC
> > > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
> > since WRITE_SYNC_PLUG doesn't work, this isn't a simple no-write-merge issue.
> >
> > > we didn't test deadline IO mode, just test cfq. seems insert write
> > > request into sync queue effect much read performance, but we don't know
> > > details. What's your comments of this?
>   Indeed it seems that the optimization of the case where we wait for the
> transaction is negatively impacting the performance when we are not. Does
> patch below help for your load? It refines the logic when WRITE_SYNC
> is needed (of course, we should also test whether the patch works for fsync
> heavy loads as well).
>   The patch is mostly a proof of concept and only lightly tested so be
> careful...
> 

I tested the patch after remove t_synchronous_commit lines in
include/trace/events/jbd2.h on 2.6.38-rc1 kernel. 
but did not find clear improvement on kbuild. 


         

