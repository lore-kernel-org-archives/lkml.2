Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0JUTXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:23:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772Ab0JUTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:23:19 -0400
Date: Thu, 21 Oct 2010 12:22:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Brian Behlendorf <behlendorf1@llnl.gov>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Message-Id: <20101021122232.10d2d573.akpm@linux-foundation.org>
In-Reply-To: <20101021181220.GA8827@redhat.com>
References: <201010121227.05735.behlendorf1@llnl.gov>
	<20101013213746.GA27248@redhat.com>
	<20101014121159.GA407@redhat.com>
	<1287683202.16680.44.camel@pip>
	<20101021181220.GA8827@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 20:12:20 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Andrew, please drop
> 
> 	lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch
> 
> On 10/21, Brian Behlendorf wrote:
> >
> > I think we should use your simpler version.  There's no good reason to
> > make this more complicated than it needs to be.  I haven't been able to
> > find a test case where your changes get the wrong result.
> 
> Great!
> 
> > From: Brian Behlendorf <behlendorf1@llnl.gov>
> > Date: Thu, 5 Aug 2010 14:59:11 -0700
> > Subject: [PATCH] Fix div64_u64 for 32bit platforms
> >
> > The current implementation of div64_u64 for 32bit systems returns
> > an approximately correct result when the divisor exceeds 32bits.
> > Since doing 64bit division using 32bit hardware is a long since
> > solved problem we just use one of the existing proven methods.
> 
> Brian, you forgot to add your sob. Hopefully Andrew can add
> 
> 	Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

OK..

Just to tie all this off, you originally said "We have a bug report
which blames div64_u64() on 32bit platforms.".  Where is that bug report?

Thanks.
