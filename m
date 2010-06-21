Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0FURlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:41:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55517 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0FURla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=o5eLVFfhBc7qst2pALHRcYhglyYXXVrUUUeLwsEENV7ABjctop9d+2iyUq6KLD7Woa
         wyqZZ18SbF24D4V8KKOZ/CHQv13yUGJXH/8UYQzm2TOCDe4uBYp0ds7I8j1xm29wutjS
         PlnGzXORtzQBgDsiPP6H9Am+cr9F+fu04G75Q=
Subject: Re: [PATCH] tracing: Fix undelared ENOSYS in
 include/linux/tracepoint.h
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1277130520.9181.12.camel@gandalf.stny.rr.com>
References: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
	 <1277130520.9181.12.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 22 Jun 2010 01:41:22 +0800
Message-ID: <1277142082.6230.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 10:28 -0400, Steven Rostedt wrote:
> On Mon, 2010-06-21 at 19:09 +0800, Wu Zhangjin wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > The header file include/linux/tracepoint.h may be included without
> > include/linux/errno.h and then the compiler will fail on building for
> > undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
> > to include/linux/tracepoint.h.
> > 
> 
> Hi Wu,
> 
> I have not hit this. Did you hit this with mips? Does it need to get
> into 2.6.35 or can it wait till 2.6.36?
> 

I did not hit this in the mainline linux but in the windriver linux
(2.6.34). some guys (from WR) have included the <linux/kmemtrace.h> in
lib/kernel_lock.c and have introduced the building failure under some
configurations(seems when disabling the LTTng and another config, sorry,
I forget the exact name).

I have tried to find out who have used the undeclared ENOSYS and at last
got include/linux/tracepoint.h and after checking the linux-next tree
and found it also need to declare ENOSYS, then I send this patch for I'm
worrying about somebody else may also include tracepoint.h but without
errno.h ;)

Perhaps we'd better push it into 2.6.35 as you explained: "maybe there's
a configuration already in 35 that we don't know about that this bug can
break. "

Best Regards,
	Wu Zhangjin

> -- Steve
> 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > ---
> >  include/linux/tracepoint.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 9a59d1f..103d1b6 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -14,6 +14,7 @@
> >   * See the file COPYING for more details.
> >   */
> >  
> > +#include <linux/errno.h>
> >  #include <linux/types.h>
> >  #include <linux/rcupdate.h>
> >  
> 
> 


