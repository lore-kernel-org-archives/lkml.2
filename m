Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1DLVdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:33:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932568Ab1DLVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:33:46 -0400
Date: Tue, 12 Apr 2011 14:33:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov, oleg@redhat.com
Subject: Re: [PATCH] remove abs64()
Message-Id: <20110412143340.e26fc370.akpm@linux-foundation.org>
In-Reply-To: <20110412211658.GB20135@p183>
References: <20110412210045.GA19901@p183>
	<20110412140726.3f4f2a7b.rdunlap@xenotime.net>
	<20110412141040.a5706346.akpm@linux-foundation.org>
	<20110412211658.GB20135@p183>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 00:16:58 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Apr 12, 2011 at 02:10:40PM -0700, Andrew Morton wrote:
> > On Tue, 12 Apr 2011 14:07:26 -0700
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > > +	__builtin_choose_expr(						\
> > > > +		__builtin_types_compatible_p(typeof(_x), long long),	\
> > > > +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> > > > +	_x)))));							\
> > > > +})
> > > 
> > > that is better?
> > 
> > I think so.
> > 
> > It's a bit concerning that it changes the return type of abs().
> 
> I haven't read every abs() user, but, yes, sizeof(abs()) silently
> changing is the issue.

It changes signedness_of(abs(signed_expr)) as well.  That changes the
signedness of expressions which use abs() and on and on.
