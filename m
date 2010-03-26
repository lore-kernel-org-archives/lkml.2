Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0CZLwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 07:52:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0CZLwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 07:52:42 -0400
Subject: Re: set_cpus_allowed_ptr
From: Peter Zijlstra <peterz@infradead.org>
To: Julia Lawall <julia@diku.dk>
Cc: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1003261218410.27328@ask.diku.dk>
References: <1269597796.12097.133.camel@laptop>
	 <Pine.LNX.4.64.1003261218410.27328@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 12:52:38 +0100
Message-ID: <1269604358.12097.143.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 12:22 +0100, Julia Lawall wrote:
> On Fri, 26 Mar 2010, Peter Zijlstra wrote:
> 
> > Hi,
> > 
> > Would it make sense to clean up the set_cpus_allowed() vs
> > set_cpus_allowed_ptr() mess using the semantic patch tool?
> > 
> > I guess it would be three patches:
> >  1) converting the current remaining set_cpus_allowed() users into
> >     set_cpus_allowed_ptr().
> >  2) remove set_cpus_allowed().
> >  3) rename set_cpus_allowed_ptr() to set_cpus_allowed()
> 
> Perhaps a subtlety is that set_cpus_allowed is creating a new variable, 
> whose address it sends to set_cpus_allowed_ptr?

Yes it does that, but I don't think that actually matters,
set_cpus_allowed_ptr()'s arg is const, so making that temporary copy
shouldn't have any side effects.



