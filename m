Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1KSAnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:43:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1KSAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:43:12 -0500
Date: Fri, 18 Nov 2011 18:43:02 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, richard@nod.at,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: user namespace: make signal.c respect user namespaces (v5)
Message-ID: <20111119004302.GB16259@sergelap>
References: <20111117045230.GA26345@hallyn.com>
 <m1aa7u2jv1.fsf@fess.ebiederm.org>
 <20111118173752.GB11823@sergelap>
 <m14ny12rra.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ny12rra.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge.hallyn@canonical.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> There is a small bug here.  You want to fixup q->info, not info.
> >> Otherwise you might try dereferencing one of the special signals and get
> >> a NULL pointer dereference.
> >
> > Thanks, Eric.  Oddly I've not seen this happen in quite a bit of
> > testing with the kernel, but you certainly must be right.  I sent
> > out a new patch to fix that.
> 
> You clearly have a different test case than I do.

I ran a good chunk of ltp...  and it passed.  I can't explain it.
 
> I managed to trigger the oops  within about 5 minutes of just fooling
> around.
> 
> You want to say &q->info not q->info in your updated patch.

Oh, yes, thanks.  Sorry, I shouldn't have sent that one as I wasn't able
to compile and test until tonight.

-serge
