Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0CSH5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:57:22 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51492 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0CSH5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:57:21 -0400
Date: Fri, 19 Mar 2010 08:57:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
       "Shi, Alex" <alex.shi@intel.com>
Subject: Re: [RFC]cfq-iosched: fix a kbuild regression
Message-ID: <20100319075719.GM5768@kernel.dk>
References: <20100316025656.GA15390@sli10-desk.sh.intel.com> <20100317133019.GV5768@kernel.dk> <4e5e476b1003171124y791a25a8n6c31368f182b52a9@mail.gmail.com> <20100318010459.GA26716@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318010459.GA26716@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18 2010, Shaohua Li wrote:
> On Thu, Mar 18, 2010 at 02:24:10AM +0800, Corrado Zoccolo wrote:
> > On Wed, Mar 17, 2010 at 2:30 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Tue, Mar 16 2010, Shaohua Li wrote:
> > >> Alex Shi reported a kbuild regression which is about 10% performance lost.
> > >> He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
> > >> The reason is cfqq_close() can't find close cooperator. If we store the seek
> > >> distance to the value before the commit like below, the regression fully goes
> > >> away. If this is too invasive, just changing the cfq_rq_close() for the
> > >> !for_preempt is ok too.
> > >
> > > Corrado, any objections to widening the seek threshold?
> > 
> > The previous seek threshold value was meant to be compared with the
> > average seek distance, so it was large to account for variations.
> > Since we handle the variations differently, we should have a smaller
> > value now (the 100 * 8 was the result of a benchmark run on several
> > disks).
> Our test doesn't find any issue with the seek threshold so far, so it proberly
> is ok.
> 
> > I agreee, though, that for merging queues, it is now too small, so we
> > should have two thresholds, the current one used to determine if a
> > request causes a seek, and an other to be used inside cfq_close (with
> > the older value, regardless of for_preempt).
> That makes sense. Updated patch.
> 
> 
> Alex Shi reported a kbuild regression which is about 10% performance lost.
> He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
> The reason is cfqq_close() can't find close cooperator. Restoring 
> cfq_rq_close()'s threshold to original value makes the regression go away.
> 
> Since for_preempt parameter isn't used anymore, this patch deletes it.

Thanks, I have applied it.

-- 
Jens Axboe

