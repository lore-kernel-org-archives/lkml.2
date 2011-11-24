Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1KXRnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:43:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab1KXRns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:43:48 -0500
Date: Thu, 24 Nov 2011 19:43:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111124174324.GB21770@redhat.com>
References: <20111117123029.GB16853@redhat.com>
 <1321534159.27735.33.camel@twins>
 <20111121131739.GF16853@redhat.com>
 <1322140980.2921.49.camel@twins>
 <20111124134542.GK2557@redhat.com>
 <1322144284.2921.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322144284.2921.59.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 03:18:04PM +0100, Peter Zijlstra wrote:
> > > But is there really any other user for this? All the trace bits are root
> > > only iirc and kvm itself only sets them on the guest kernel I think for
> > > paravirt, so that's not a problem.
> > > 
> > The problem I am trying to fix with this patch is not strictly
> > virtualization related. 
> 
> No I know, its about user-trigerably jump_label conversions, but afaik
> that's only perf. The others: tracepoints, and paravirt can't be toggled
> by unpriv. users.
Currently it may be only perf, I haven't checked. But as jump_label will gain
more users the problem may become more widespread.  Now that I know
how jump_label work I will look into changing some KVM ifs into it. If
some of them will be triggered by a guest action (for instance enabling
debug, or entering real mode) they will have to be throttled too. But
this is just speculation at this point. What is important is fixing the
one we have now. I looked into doing it outside of jump_label code, but
then I saw that I need to duplicate most of
jump_label_inc/jump_label_dec code in perf so I went for more general
solution.

--
			Gleb.
