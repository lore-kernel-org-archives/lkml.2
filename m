Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1FBVY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:24:57 -0400
Received: from sous-sol.org ([216.99.217.87]:45182 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752381Ab1FBVY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:24:56 -0400
Date: Thu, 2 Jun 2011 14:23:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Chris Wright <chrisw@sous-sol.org>, CAI Qian <caiqian@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Izik Eidus <ieidus@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ksm: fix race between ksmd and exiting task
Message-ID: <20110602212348.GM23047@sequoia.sous-sol.org>
References: <20110601222032.GA2858@thinkpad>
 <2144269697.363041.1306998593180.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <20110602141927.GA2011@thinkpad>
 <20110602164841.GK23047@sequoia.sous-sol.org>
 <20110602173549.GL23047@sequoia.sous-sol.org>
 <20110602201236.GB4114@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602201236.GB4114@thinkpad>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi (andrea@betterlinux.com) wrote:
> On Thu, Jun 02, 2011 at 10:35:49AM -0700, Chris Wright wrote:
> > Andrea Righi reported a case where an exiting task can race against
> > ksmd.
> > 
> > ksm_scan.mm_slot == the only registered mm
> > CPU 1 (bug program)		CPU 2 (ksmd)
> >  				list_empty() is false
> > lock
> > ksm_scan.mm_slot
> > list_del
> > unlock
> >  				slot == &ksm_mm_head (but list is now empty_)
> > 
> > Close this race by revalidating that the new slot is not simply the list
> > head again.
> 
> I confirm this fixes the problem on my side.
> 
> Tested-by: Andrea Righi <andrea@betterlinux.com>

Great, thanks for verifying.

thanks,
-chris
