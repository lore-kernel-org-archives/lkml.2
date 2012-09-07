Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab2IGJnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:43:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533Ab2IGJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:43:06 -0400
Date: Fri, 7 Sep 2012 10:43:00 +0100
From: Mel Gorman <mgorman@suse.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Ben Hutchings <ben@decadent.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Memory policy corruption fixes V2
Message-ID: <20120907094300.GY11266@suse.de>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de>
 <20120821072901.GD1657@suse.de>
 <CA+5PVA7KLmrZGDdaA0zc8nXf3sidwN2VUjWC_k6AjVwHq0dcvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+5PVA7KLmrZGDdaA0zc8nXf3sidwN2VUjWC_k6AjVwHq0dcvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:40:21AM -0400, Josh Boyer wrote:
> On Tue, Aug 21, 2012 at 3:29 AM, Mel Gorman <mgorman@suse.de> wrote:
> > On Mon, Aug 20, 2012 at 05:36:29PM +0100, Mel Gorman wrote:
> >> This is a rebase with some small changes to Kosaki's "mempolicy memory
> >> corruption fixlet" series. I had expected that Kosaki would have revised
> >> the series by now but it's been waiting a long time.
> >>
> >> Changelog since V1
> >> o Rebase to 3.6-rc2
> >> o Editted some of the changelogs
> >> o Converted sp->lock to sp->mutex to close a race in shared_policy_replace()
> >> o Reworked the refcount imbalance fix slightly
> >> o Do not call mpol_put in shmem_alloc_page.
> >>
> >> I tested this with trinity with CONFIG_DEBUG_SLAB enabled and it passed. I
> >> did not test LTP such as Josh reported a problem with or with a database that
> >> used shared policies like Andi tested. The series is almost all Kosaki's
> >> work of course. If he has a revised series that simply got delayed in
> >> posting it should take precedence.
> >
> > I meant to add Josh to the cc, adding him now.
> 
> Thank you.
> 
> I see Andi has done some testing and Acked this patchset.  Christoph
> appears to have Acked it as well.  Is there anything else needed for
> it to get in mainline? 

Not that I'm aware of.

> Just want to make sure this doesn't get dropped
> because we all forgot about it after KS/Plumbers.
> 

Right now it's in linux-next via Andrew. Bar major surprises I expect
it'll end up in mainline in due course. When it does, I'll do a -stable
backport.

-- 
Mel Gorman
SUSE Labs
