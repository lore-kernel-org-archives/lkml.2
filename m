Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1EQAL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 20:11:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53663 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab1EQAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 20:11:56 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: John Stultz <john.stultz@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <1305590200.2503.48.camel@Joe-Laptop>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
	 <1305580757-13175-3-git-send-email-john.stultz@linaro.org>
	 <4DD19D10.3000201@gmail.com>  <1305587432.2915.57.camel@work-vm>
	 <1305590200.2503.48.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 17:11:43 -0700
Message-ID: <1305591103.2915.70.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 16:56 -0700, Joe Perches wrote:
> On Mon, 2011-05-16 at 16:10 -0700, John Stultz wrote:
> > On Mon, 2011-05-16 at 23:54 +0200, Jiri Slaby wrote:
> > > > In my attempt to clean up unprotected comm access, I've noticed
> > > > most comm access is done for printk output. To simplify correct
> > > > locking in these cases, I've introduced a new %ptc format,
> > > > which will print the corresponding task's comm.
> > > > Example use:
> > > > printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
> > > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > > > +static noinline_for_stack
> > > Actually, why noinline? Did your previous version have there some
> > > TASK_COMM_LEN buffer or anything on stack which is not there anymore?
> > No, I was just following how almost all of the pointer() called
> > functions were declared.
> > But with two pointers and a long, I add more then ip6_string() has on
> > the stack, which uses the same notation.
> > But I can drop that bit if there's really no need for it.
> 
> vsprintf can be recursive, I think you should keep it.

Ok. I'll keep it then. Thanks!
-john


