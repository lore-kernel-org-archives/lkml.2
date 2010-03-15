Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab0COSpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:45:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:62260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0COSpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VmUmGMN1x0e8f4FnBTpqwPbmCXmAnVx1ZWu/0Zo7zR2tPLxZHZfdVErtzPMuZfqJdf
         HSZBUtioZpoC60Gqj4dN7YC4GVDZ8Fx3bgkOG4qmH1CtJdl0VI7mmyGpsZLcnDyeC/MR
         +BTTc99Xg2wMRLLR1wo/eaqUkd79dauuMzH6o=
Date: Tue, 16 Mar 2010 00:15:06 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 03/10] ftrace: allow building without frame pointers
Message-ID: <20100315184506.GA2303@debian>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
 <1268462987-8271-4-git-send-email-rabin@rab.in>
 <1268501792.3366.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268501792.3366.7.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 12:36:32PM -0500, Steven Rostedt wrote:
> On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> >  ifdef CONFIG_FRAME_POINTER
> >  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> >  else
> > +# Some targets (ARM with Thumb2, for example), can't be built with frame
> > +# pointers.  For those, we don't have FUNCTION_TRACER automatically
> > +# select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
> > +# incompatible with -fomit-frame-pointer with current GCC, so we don't use
> > +# -fomit-frame-pointer with FUNCTION_TRACER.
> > +ifndef CONFIG_FUNCTION_TRACER
> >  KBUILD_CFLAGS	+= -fomit-frame-pointer
> 
> I believe this is correct, but have you tested this on other archs other
> than ARM? I can do it for x86 and PPC, but it will need to wait as those
> machines are currently performing stress tests.

I've tested the series on x86-64.

Note that this particular change will not currently affect other archs
since they still have the "select FRAME_POINTER" in FUNCTION_TRACER.

Rabin
