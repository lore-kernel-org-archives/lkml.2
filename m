Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1JQRXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1JQRXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:23:07 -0400
Date: Mon, 17 Oct 2011 13:22:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Message-ID: <20111017172229.GH5795@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017160904.GG5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE911C66@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EE911C66@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 09:56:50AM -0700, Luck, Tony wrote:
> > All this lock busting probably isn't pretty and causes one to reflect what
> > is going on here.  But as long as we are going to keep the kmsg_dump
> > design, changes like this seem necessary to make sure the locking stays
> > sane(r) for now.
> 
> So should we let the back-end know that locks have been busted?  I worry
> that we'll get through the pstore layer by blasting away at any locks that
> get in our way - but then the backend (which may well have been written on
> the assumption that pstore serialized calls to it) will not do anything
> useful (and may cause its own hang).

I was kinda alluding to something like that, when I said we probably need
follow on patches to clean up the backend.  But maybe it would be smarter
to set a flag in pstore to let the backend know we busted the locks
instead of letting them do panic checks themselves.  I agree with your
concerns.

I really can't think of a good overall solution other than slowly
step-by-step untangle things by making subtle changes, this round being
the serialization of kmsg_dump().

My brain is to small to figure this out.  I keep thinking about making an
ascii art diagram to see all the various paths and their contexts, but
then I keep finding more interesting things to do. :-)

Perhaps we should do that and make some rules about what the back-end can
and can not do when plugging into kmsg_dump.

Cheers,
Don

