Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1EUWiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 18:38:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:38344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab1EUWiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 18:38:07 -0400
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: Peter Zijlstra <peterz@infradead.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTinvtfpPr3GxKA49MN4y1q66HETorQ@mail.gmail.com>
References: <201105191526.31904.toralf.foerster@gmx.de>
	 <1305907458.1465.23.camel@gandalf.stny.rr.com>
	 <1305907896.1465.27.camel@gandalf.stny.rr.com>
	 <201105210053.51314.toralf.foerster@gmx.de>
	 <BANLkTinvtfpPr3GxKA49MN4y1q66HETorQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 22 May 2011 00:37:36 +0200
Message-ID: <1306017456.18455.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 12:12 +0200, richard -rw- weinberger wrote:
> 2011/5/21 Toralf Förster <toralf.foerster@gmx.de>:
> > Bisecting gave :
> >
> >
> > git bisect badd123375425d7df4b6081a631fc1203fceafa59b2 is the first bad commit
> > commit d123375425d7df4b6081a631fc1203fceafa59b2
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Wed Jan 26 21:32:01 2011 +0100
> >
> >    rwsem: Remove redundant asmregparm annotation
> >
> >    Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
> >    compiling the kernel already with -mregparm=3. So the annotation of
> >    the rwsem functions is redundant. Remove it.
> 
> Ok, this bisect makes much more sense.
> 
> Thomas, Peter, please revert d123375425d7df4b6081a631fc1203fceafa59b2.
> We cannot compile UML with -mregparm=3 it would cause a lot of trouble.
> It would break 32bit UML on 64bit and also on older 32bit systems like RHEL5.

But why? 

Also, having to carry that asmregparm notation just for uml doesn't seem
worth the trouble.
