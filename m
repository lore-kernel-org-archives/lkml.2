Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0GHLCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:02:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab0GHLCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:02:13 -0400
Subject: Re: FYI: mmap_sem OOM patch
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100708195421.CD48.A69D9226@jp.fujitsu.com>
References: <AANLkTimLSnNot2byTWYuIHE8rhGLXbl1zKsQQhmci1Do@mail.gmail.com>
	 <1278586173.1900.50.camel@laptop>
	 <20100708195421.CD48.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 13:02:01 +0200
Message-ID: <1278586921.1900.67.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 19:57 +0900, KOSAKI Motohiro wrote:
> > On Thu, 2010-07-08 at 03:39 -0700, Michel Lespinasse wrote:
> > > 
> > > 
> > >         One way to fix this is to have T4 wake from the oom queue and return an
> > >         allocation failure instead of insisting on going oom itself when T1
> > >         decides to take down the task.
> > > 
> > > How would you have T4 figure out the deadlock situation ? T1 is taking down T2, not T4... 
> > 
> > If T2 and T4 share a mmap_sem they belong to the same process. OOM takes
> > down the whole process by sending around signals of sorts (SIGKILL?), so
> > if T4 gets a fatal signal while it is waiting to enter the oom thingy,
> > have it abort and return an allocation failure.
> > 
> > That alloc failure (along with a pending fatal signal) will very likely
> > lead to the release of its mmap_sem (if not, there's more things to
> > cure).
> > 
> > At which point the cycle is broken an stuff continues as it was
> > intended.
> 
> Now, I've reread current code. I think mmotm already have this.

<snip code>

[ small note on that we really should kill __GFP_NOFAIL, its utter
deadlock potential ]

> Thought?

So either its not working or google never tried that code?


