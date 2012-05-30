Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2E3Twr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:52:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48455 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2E3Twp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:52:45 -0400
Date: Wed, 30 May 2012 21:52:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        stable@vger.kernel.org, hughd@google.com, sivanich@sgi.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
Message-ID: <20120530195244.GX27374@one.firstfloor.org>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org> <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org> <alpine.DEB.2.00.1205301441350.31768@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301441350.31768@router.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:42:42PM -0500, Christoph Lameter wrote:
> On Wed, 30 May 2012, Andi Kleen wrote:
> 
> > On Wed, May 30, 2012 at 01:50:02PM -0500, Christoph Lameter wrote:
> > > On Wed, 30 May 2012, Andi Kleen wrote:
> > >
> > > > I always regretted that cpusets were no done with custom node lists.
> > > > That would have been much cleaner and also likely faster than what we have.
> > >
> > > Could shared memory policies ignore cpuset constraints?
> >
> > Only if noone uses cpusets as a "security" mechanism, just for a "soft policy"
> > Even with soft policy you could well break someone's setup.
> 
> Well at least lets exempt shared memory from memory migration and memory
> policy updates. That seems to be causing many of these issues.

Migration on the page level is needed for the memory error handling.

Updates: you mean not allowing to set the policy when there are already
multiple mappers? I could see that causing some unexpected behaviour. Presumably
a standard database will only set it at the beginning, but I don't know
if that would work for all users.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
