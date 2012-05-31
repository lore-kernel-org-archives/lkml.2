Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2EaD4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 23:56:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57441 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2EaDz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 23:55:58 -0400
Message-ID: <1338436524.2659.32.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 23:55:24 -0400
In-Reply-To: <20120531005607.GB11775@ZenIV.linux.org.uk>
References: <20120530163605.GV11775@ZenIV.linux.org.uk>
	 <1338406967.2257.24.camel@localhost>
	 <20120530202427.GW11775@ZenIV.linux.org.uk>
	 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
	 <20120530205612.GY11775@ZenIV.linux.org.uk>
	 <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
	 <20120530213638.GZ11775@ZenIV.linux.org.uk>
	 <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
	 <20120531002802.GA11775@ZenIV.linux.org.uk>
	 <CA+55aFzDeZQeFY1i1xLES4ijtDeGBk3EBOh-mA0dhEH2yaGf9A@mail.gmail.com>
	 <20120531005607.GB11775@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053103-7282-0000-0000-0000097A700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 01:56 +0100, Al Viro wrote:
> On Wed, May 30, 2012 at 05:40:54PM -0700, Linus Torvalds wrote:
> > On Wed, May 30, 2012 at 5:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > FWIW, I think it's cleaner to take the whole thing into an inlined helper.
> > 
> > Even better.
> > 
> > I notice that your inlined helper doesn't do what I did: if PROT_EXEC
> > is already set, stop all the stupid games. IOW, the first test in that
> > function could as well be
> > 
> >     if (prot & (PROT_READ | PROT_EXEC) != PROT_READ)
> >         return prot;
> > 
> > because if PROT_EXEC is already set, or if PROT_READ wasn't set, none
> > of the rest of the checks make any sense at all.
> 
> Point...  OK, done, pushed and the whole thing thrown into #for-next.

Patch "split cap_mmap_addr() out of cap_file_mmap()" contains the typo
'cat_mmap_addr', which is then removed in
"split ->file_mmap() into ->mmap_addr()/->mmap_file()".

> Probably too late for today's linux-next, but tomorrow one should pick
> that.  BTW, tomorrow there'll be a signal.git pull request as well,
> with task_work_add() series in it.
> 
> Now for the Miklos' stuff...
> 


