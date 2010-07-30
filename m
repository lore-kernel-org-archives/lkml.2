Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0G3Gh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 02:37:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54116 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0G3Gh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 02:37:28 -0400
Date: Fri, 30 Jul 2010 12:07:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-ID: <20100730063711.GN14369@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201007282334.08063.rjw@sisk.pl>
 <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
 <20100729142245.4AA5.A69D9226@jp.fujitsu.com>
 <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
 <20100730041825.GM14369@balbir.in.ibm.com>
 <AANLkTi=HFg9zcAoUZbYzT2j7X11oDZs=xgrJynT=3GM6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTi=HFg9zcAoUZbYzT2j7X11oDZs=xgrJynT=3GM6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hughd@google.com> [2010-07-29 21:32:35]:

> On Thu, Jul 29, 2010 at 9:18 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> > Couldn't we reuse PF_* flags to differentiate between the paths, if
> > that is what it eventually boils down to? On an unrelated note, I was
> > looking at shrink_all_memory() and wondering if swappiness really
> > mattered there.
> 
> So far as the swap-reuse issue goes, I don't see that a PF_ flag
> would help: the threads that already worry about such issues do
> the set_freezable()/try_to_freeze() thing, and won't get into
> trouble anyway; we don't want to force every other thread to
> have to do something special now, better just check global state
> in the very few places its needed.
>

We already do that with PF_MEMALLOC in several places. If the goal is
to avoid resuing the swap entry at all times after hibernate, the
solution needs to be a global state solution like you suggest.
 
> On the unrelated note: better in an unrelated thread!
>

Sure :)
 
-- 
	Three Cheers,
	Balbir
