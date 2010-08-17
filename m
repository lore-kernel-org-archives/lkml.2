Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab0HQOVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:21:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0HQOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:21:50 -0400
Date: Tue, 17 Aug 2010 16:21:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] [PATCH 2/4] dio: add page locking for direct I/O
Message-ID: <20100817142144.GB18161@basil.fritz.box>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1008110806070.673@router.home>
 <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
 <20100812075941.GD6112@spritzera.linux.bs1.fc.nec.co.jp>
 <x49aaos3q2q.fsf@segfault.boston.devel.redhat.com>
 <20100816020737.GA19531@spritzera.linux.bs1.fc.nec.co.jp>
 <x49aaomheyi.fsf@segfault.boston.devel.redhat.com>
 <20100817081753.GA28762@spritzera.linux.bs1.fc.nec.co.jp>
 <x4939uduzan.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x4939uduzan.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 09:46:56AM -0400, Jeff Moyer wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > BTW, from the discussion with Christoph I noticed my misunderstanding
> > about the necessity of additional page locking. It would seem that
> > without page locking there is no danger of racing between direct I/O and
> > page migration. So I retract this additional locking patch-set.
> 
> OK, great!  ;-)

Well it sounds like we still may need something. It isn't good if O_DIRECT
can starve (or DoS) migration.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
