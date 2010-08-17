Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0HQQl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:41:59 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43129 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750837Ab0HQQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:41:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: obyojlkVM1ls_9A4V7WiN1UC4vH1PZrjpE80HlO7BZrqveh
 sQ_SeMyOzXs0selbYZKXliL9Y2Y74lovt7g21tl4qYUXWZvpuPJtUhvZEPF1
 qZEYYlT0GfQ_1frjyvmYXcbP1rHbq27oSNzhkGWH3bs.ZulzWya7iJNPkX8c
 kVBRMUtBS6hES5ZNOtSBCuKNpuDIHHLJ4zOhur67pg7SKjPNUiklKf3UyVwN
 rIHYpPiBWLDvoRkDAtjRLg_Y9zX4fSjE-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 Aug 2010 11:41:52 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Jeff Moyer <jmoyer@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] [PATCH 2/4] dio: add page locking for direct I/O
In-Reply-To: <20100817142144.GB18161@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.1008171140300.11174@router.home>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.00.1008110806070.673@router.home> <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp> <20100812075941.GD6112@spritzera.linux.bs1.fc.nec.co.jp>
 <x49aaos3q2q.fsf@segfault.boston.devel.redhat.com> <20100816020737.GA19531@spritzera.linux.bs1.fc.nec.co.jp> <x49aaomheyi.fsf@segfault.boston.devel.redhat.com> <20100817081753.GA28762@spritzera.linux.bs1.fc.nec.co.jp> <x4939uduzan.fsf@segfault.boston.devel.redhat.com>
 <20100817142144.GB18161@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Andi Kleen wrote:

> On Tue, Aug 17, 2010 at 09:46:56AM -0400, Jeff Moyer wrote:
> > Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> >
> > > BTW, from the discussion with Christoph I noticed my misunderstanding
> > > about the necessity of additional page locking. It would seem that
> > > without page locking there is no danger of racing between direct I/O and
> > > page migration. So I retract this additional locking patch-set.
> >
> > OK, great!  ;-)
>
> Well it sounds like we still may need something. It isn't good if O_DIRECT
> can starve (or DoS) migration.

Anything that increments a page refcount can interfere with migration and
cause migration to be aborted and retried later. Not something new. There
never was any guarantee that migration must succeed.


