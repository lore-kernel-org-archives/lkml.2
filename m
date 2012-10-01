Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2JAUzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab2JAUzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:55:08 -0400
Date: Mon, 1 Oct 2012 16:41:50 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.hengli.com.au,
        pjones@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Message-ID: <20121001204150.GA20849@hansolo.jdub.homelinux.org>
References: <87wqzdnwus.fsf@rustcorp.com.au>
 <87ipay3cof.fsf@rustcorp.com.au>
 <87bogs492s.fsf@rustcorp.com.au>
 <87ehlp30pd.fsf@rustcorp.com.au>
 <5555.1348531649@warthog.procyon.org.uk>
 <8168.1348650575@warthog.procyon.org.uk>
 <16088.1348736905@warthog.procyon.org.uk>
 <27378.1348819793@warthog.procyon.org.uk>
 <29407.1348902805@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29407.1348902805@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 08:13:25AM +0100, David Howells wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > [    2.808075] Loading module verification certificates
> > [    2.809331] X.509: Cert 6e03943da0f3b015ba6ed7f5e0cac4fe48680994 has expired
> > [    2.810500] MODSIGN: Problem loading in-kernel X.509 certificate (-127)
> 
> Hmmm...  Other people have seen that.
> 
> Ahhhhh!
> 
> I wonder if the problem is that the certificate is valid for 100 years....
> That might well cause an overflow on a 32-bit system.

That does seem quite plausible.  The comparisons are done with time_t,
which boils down to 'long' and 100 years in seconds would overflow
LONG_MAX.

> Could you try changing the '36500' in kernel/Makefile to something shorter,
> like 365?

I tried two values today.  One close to LONG_MAX (24800 or ~68 years),
and 10 years (3650).  The former still seemed to overflow, but
specifying a 10yr lifetime appears to have worked.

josh
