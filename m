Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1ITLLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 07:11:06 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39831 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1ITLLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 07:11:03 -0400
Date: Tue, 20 Sep 2011 16:39:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Ken Chen <kenchen@google.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110920110937.GA5911@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1315931775.5977.29.camel@twins>
 <20110913175425.GB3062@linux.vnet.ibm.com>
 <1315937995.4226.9.camel@twins>
 <20110913182841.GO11100@linux.vnet.ibm.com>
 <1315938646.4226.12.camel@twins>
 <20110913183502.GP11100@linux.vnet.ibm.com>
 <20110915175537.GA17701@linux.vnet.ibm.com>
 <1316123323.4060.24.camel@twins>
 <20110919175129.GA11164@linux.vnet.ibm.com>
 <CABeCy1bmUK=meSEUYOuOeyP8ZLYDGG1xpNC51jevs-fXHmUUtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABeCy1bmUK=meSEUYOuOeyP8ZLYDGG1xpNC51jevs-fXHmUUtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11092002-3568-0000-0000-00000054A4FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Venki Pallipadi <venki@google.com> [2011-09-19 17:38:26]:

> On Mon, Sep 19, 2011 at 10:51 AM, Kamalesh Babulal
> <kamalesh@linux.vnet.ibm.com> wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-15 23:48:43]:
> >
> >> On Thu, 2011-09-15 at 23:25 +0530, Kamalesh Babulal wrote:
> >> > 2.6.38          | 1551  | 48    | 62    | 47    | 50    |
> >> > ----------------+-------+-------+-------+-------+-------+
> >> > 2.6.39          | 3784  | 457   | 722   | 3209  | 1037  |
> >>
> >> I'd say we wrecked it going from .38 to .39 and only made it worse after
> >> that.
> >
> > after reverting the commit 866ab43efd325fae8889ea, of the patches
> > went between .38 and .39 reduces the ping pong of the tasks.
> 
> There was a side-effect from 866ab43efd325fae8889ea that Ken
> identified and fixed later in commit
> b0432d8f162c7d5d9537b4cb749d44076b76a783. I guess you are seeing the
> same problem...
(snip)

3.1-rc4+tip includes the commit b0432d8f162c7d5d. The number of task
ping pongs has reduced with 3.1-rc4+tip, in comparison to 2.6.39 as 
seen in the below table. Reverting the commit 866ab43efd325fa on the 
3.1-rc4+tip reduces the task bouncing to a good extend.

> > ------------------------+-------+-------+-------+-------+-------+
> > Kernel                  | Run 1 | Run 2 | Run 3 | Run 4 | Run 5 |
> > ------------------------+-------+-------+-------+-------+-------+
> > 2.6.39                  | 1542  | 2172  | 2727  | 120   | 3681  |
> > ------------------------+-------+-------+-------+-------+-------+
> > 2.6.39 (with            |       |       |       |       |       |
> > 866ab43efd reverted)    | 65    | 78    | 58    | 99    | 62    |
> > ------------------------+-------+-------+-------+-------+-------+
> > 3.1-rc4+tip             |       |       |       |       |       |
> > (e467f18f945c)          | 1219  | 2037  | 1943  | 772   | 1701  |
> > ------------------------+-------+-------+-------+-------+-------+
> > 3.1-rc4+tip (e467f18f9) |       |       |       |       |       |
> > (866ab43efd reverted)   | 64    | 45    | 59    | 59    | 69    |
> > ------------------------+-------+-------+-------+-------+-------+
> >

