Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2D3OdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:33:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45811 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2D3OdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:33:21 -0400
Message-ID: <1335796351.1827.6.camel@falcor>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Jonathan Corbet <corbet@lwn.net>, Kasatkin, Dmitry" 
	<dmitry.kasatkin@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 30 Apr 2012 10:32:31 -0400
In-Reply-To: <20120427173417.GK6871@ZenIV.linux.org.uk>
References: <1334865448.2429.35.camel@falcor>
	 <20120420004303.GB6871@ZenIV.linux.org.uk>
	 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
	 <20120420190418.GK6871@ZenIV.linux.org.uk>
	 <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
	 <20120420195833.GM6871@ZenIV.linux.org.uk>
	 <CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
	 <20120420221315.GN6871@ZenIV.linux.org.uk>
	 <CA+55aFzEwsW1kdLo2hpgW2PUCRkyaRxS_KB40iwmuk1FDgV+cg@mail.gmail.com>
	 <CALLzPKarZY11htkukZPi+7ny5r=au9hMdKBOy20wAdFjSBOyjA@mail.gmail.com>
	 <20120427173417.GK6871@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043014-4242-0000-0000-0000017F3A1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 18:34 +0100, Al Viro wrote:
> On Fri, Apr 27, 2012 at 10:35:25AM +0300, Kasatkin, Dmitry wrote:
> 
> > But have you seen the proposed patch for __fput()?
> > [PATCH v4 10/12] ima: defer calling __fput()
> > 
> > It defers only of course the last AND mmap_sem is locked AND open for write.
> > 
> > 	if (current->mm && rwsem_is_locked(&current->mm->mmap_sem)) {
> > 		if (ima_defer_fput(file) == 0)
> > 			return;
> > 	}
> > 
> > Just 5 out of ~100,000 mmap_sem held fput() calls were deferred.
> 
> Let me get it straight.
> 	a) You still ignore all the problems with that described in the
> posting right in the beginning of this thread.
> 	b) You ignore the problems with semantics changes from user-visible
> delays of fput() past the return from syscall (described in Linus' posting
> upthread - they apply to this "solution" as well).
> 	c) You seem to consider the fact that this path will be exercised
> very rarely, thus making any races on it damn hard to reproduce and debug
> as a good thing.  
> 
> And as for the sentiment expressed in the beginning of your posting (that
> smaller patch size is worth more than clean locking rules, maintainability
> of resulting kernel, etc.)...  I'm sorry, but you guys need to decide
> what IMA is.  If it's a first-class part of the kernel, you have your
> priorities backwards...

Al, with all this time spent on the different components of the
integrity subsystem, making it a first class citizen is our main
concern.  We definitely appreciate all of your work, previous and
current work on fput, to help make this happen and will be happy to help
in any way possbile.

Jon, thank you for summarizing the discussion - article
http://lwn.net/Articles/494158/.  As Jake Edge's previous LWN article
http://lwn.net/Articles/488906/ said, we've been working on upstreaming
the different integrity components for quite a while.  Although
IMA-appraisal isn't the last component, it is a major one and were
hoping that it would be upstreamed in the near future.  Is 3.5 still a
possibility?

(It was just pointed out to me that the discussion has moved to
linux-arch.  I'm pretty sure that other people on the LSM mailing list
are following this discussion.  In the future, please CC the LSM
mailing.)

thanks,

Mimi

