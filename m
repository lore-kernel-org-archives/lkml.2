Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0GMWTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:19:14 -0400
Received: from xenotime.net ([72.52.115.56]:50702 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753720Ab0GMWTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:19:12 -0400
Date: Tue, 13 Jul 2010 15:19:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
Message-Id: <20100713151902.ca37fc2b.rdunlap@xenotime.net>
In-Reply-To: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 17:00:21 +0300 (EEST) Dimitrios Apostolou wrote:

> Hello list,
> 
> according to Documentation/CodingStyle the "linux" style of emacs is 
> broken because it uses tabs+spaces when continuing the argument list of a 
> function on a new line. So I reported that as a bug to bug-gnu-emacs 
> (bug#6617).
> 
> However it's not clear if this is a bug of emacs or an inconsistency of 
> the linux kernel coding style. I can't find where exactly the usage *only* 
> of tabs is mandated, see for example the following quote:
> 
> 
> > Statements longer than 80 columns will be broken into sensible
> > chunks. Descendants are always substantially shorter than the parent
> > and are placed substantially to the right. The same applies to
> > function headers with a long argument list. Long strings are as well
> > broken into shorter strings. The only exception to this is where
> > exceeding 80 columns significantly increases readability and does not
> > hide information.


See CodingStyle, Chapter 1, Indentation:

"Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation, and the above example is deliberately broken."

which to me means "spaces alone are never used (unless the indentation is less than
8 columns)".


> Tabs are not mentioned anywhere, besides the specific part about emacs 
> which is so ironic that no emacs dev can read it fully. Moreover there are 
> many parts in the kernel that are aligned using both tabs and spaces. 
> Random example in the linux-2.6.34.1 kernel: kernel/sched.c
> 
> 
> static void update_group_shares_cpu(struct task_group *tg, int cpu,
>                                      unsigned long sd_shares,
>                                      unsigned long sd_rq_weight,
>                                      unsigned long *usd_rq_weight)
> {

In the example above, some email software seems to have munged tabs
into spaces, or someone used copy-and-paste, which also translated
tabs into spaces.  It should have been:

static void update_group_shares_cpu(struct task_group *tg, int cpu,
				    unsigned long sd_shares,
				    unsigned long sd_rq_weight,
				    unsigned long *usd_rq_weight)
{

which is a common usage model in the Linux kernel.

> So what do you think? Should the current emacs "linux" style be fixed, or 
> are spaces allowed?

<tab(s)>+<less than 8 spaces> are often used for function parameter alignment,
as above.  More than 7 spaces should not be used.  I don't find the function
parameter alignment very important, so sometimes I just use tabs and no spaces
and omit the parameter alignment, but mostly what I do is match the current
existing style in the code that I am working on.


I'm not an emacs (O.S.) user, but I doubt that the emacs linux style needs
to be fixed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
