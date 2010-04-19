Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0DSVbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:31:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab0DSVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:31:35 -0400
Date: Mon, 19 Apr 2010 14:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven B <damentz@gmail.com>
Cc: Frank Ren <frankrq2009@gmx.com>, mingo <mingo@elte.hu>,
       "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
       "jens.axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: high iowait problem(Bug 12309 on bugzilla.kernel.org)
Message-Id: <20100419143102.38f37fe9.akpm@linux-foundation.org>
In-Reply-To: <o2k8c2bb01004142258zd1a02d38ib2128e324b7d9947@mail.gmail.com>
References: <20100331124834.192500@gmx.com>
	<20100413135416.b537eee8.akpm@linux-foundation.org>
	<o2k8c2bb01004142258zd1a02d38ib2128e324b7d9947@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 00:58:05 -0500
Steven B <damentz@gmail.com> wrote:

> Hi Andrew,
> 
> > So something between 2.6.32.3 and 2.6.32.8 inclusive rebroke the
> > kernel. __That's useful info.
> >
> > Looking at the changelogs, the only thing I can immediately see in the
> > block-core area is
> >
> > : commit cb723ba5d03bf719dbc7409b4d67572d4472ef8b
> > : Author: Dmitry Monakhov <dmonakhov@openvz.org>
> > : Date: __ Wed Jan 27 22:44:36 2010 +0300
> > :
> > : __ __ block: fix bio_add_page for non trivial merge_bvec_fn case
> >
> > which seems unlikely.
> >
> > I'm seeing just one device-mapper change whcih went in over that
> > timeframe:
> >
> > : commit e0f5cfa7c18b411634e73923841eccd3a4c0ce7f
> > : Author: Martin K. Petersen <martin.petersen@oracle.com>
> > : Date: __ Mon Jan 11 03:21:50 2010 -0500
> > :
> > : __ __ DM: Fix device mapper topology stacking
> >
> >
> 
> Although I can't provide any big details, I went through the commits between
> 2.6.32.2 and 2.6.32.8 and as many things that could affect IO and reverted
> them from my 2.6.33.2 kernel.
> 
> Here's my list of commits I reverted that seemed to improve performance locally
> running a 2.6.33.2 kernel.
> 
> cb723ba5d03bf719dbc7409b4d67572d4472ef8b (this one you suspected)
> block: fix bio_add_page for non trivial merge_bvec_fn case
> 
> b2ea8cb9c8f1937cb80b9beb50548a05bfc37819
> vmscan: do not evict inactive pages when skipping an active list scan
> 
> e4dd8ca5be771aa706b0797b3284328bb595bfa1
> fasync: split 'fasync_helper()' into separate add/remove functions
> 
> Though, I was hoping you guys could identify which one of these is
> the real culprit.

Can you go through and revert them individually please?
