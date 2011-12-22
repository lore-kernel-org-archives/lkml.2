Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1LVL1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:27:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1LVL1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:27:53 -0500
Date: Thu, 22 Dec 2011 06:27:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net,
        Belisko Marek <marek.belisko@gmail.com>, awilliam@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
Message-ID: <20111222062721.4f4290ab@tlielax.poochiereds.net>
In-Reply-To: <4EF30D4B.9060906@linux.vnet.ibm.com>
References: <201112210054.46995.rjw@sisk.pl>
	<4EF30D4B.9060906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 16:28:19 +0530
"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> On 12/21/2011 05:24 AM, Rafael J. Wysocki wrote:
> 
> > [Evidently, vger has blocked the previous attempts to post this message
> > for some reason.  I wonder why?]
> > 
> > This message contains a list of some regressions from 3.0 and 3.1
> > for which there are no fixes in the mainline known to the tracking team.
> > If any of them have been fixed already, please let us know.
> > 
> > If you know of any other unresolved regressions from 3.0 and 3.1, please let us
> > know either and we'll add them to the list.  Also, please let us know if any of
> > the entries below are invalid.
> > 
> > The entries below are simplified and the statistics are not present due to the
> > continuing Bugzilla outage.
> > 
> 
> [...]
> 
> > 
> > Subject    : Freezing of tasks failed after 20.01 seconds in kernel 3.2.0-rc2
> > Submitter  : Belisko Marek <marek.belisko@gmail.com>
> > Date       : 2011-11-22 21:20
> > Message-ID : 
> > CAAfyv36nxYq1EA2pcHi5WR1BdWYHp2sQTY1mMA4Q3JjcOG5RDw@mail.gmail.com
> > References : http://marc.info/?l=linux-kernel&m=132199691706100&w=2
> > 
> >
> 
> 
> I believe we already have a fix for this, but not yet in mainline:
> http://thread.gmane.org/gmane.linux.nfs/45336
> 

I don't believe this is a regression at all. As far as I know, It's
always been the case that these sleeps weren't freezable. I even have
a similar bug open for RHEL6 which has a 2.6.32-based kernel...

If people are seeing this more now, then it might be some subtle
difference in timing or differences in what userspace is doing at the
time the freezer runs.

In any case, the final fix didn't make 3.2, but should go in early for
3.3.

-- 
Jeff Layton <jlayton@redhat.com>
