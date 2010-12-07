Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0LGSiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:38:12 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:45513 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab0LGSiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:38:10 -0500
Date: Tue, 7 Dec 2010 10:38:06 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5535-mfd: fix warning on x86-64
Message-ID: <20101207103806.74cc9f48@queued.net>
In-Reply-To: <20101130100137.GA11125@sortiz-mobl>
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
	<20101129204410.339805ef@queued.net>
	<20101130100137.GA11125@sortiz-mobl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 11:01:38 +0100
Samuel Ortiz <sameo@linux.intel.com> wrote:

> Hi Andres,
> 
> On Mon, Nov 29, 2010 at 08:44:10PM -0800, Andres Salomon wrote:
> > On Mon, 29 Nov 2010 11:52:57 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Samuel,
> > > 
> > > After merging the mfd tree, today's linux-next build (x86_64
> > > allmodconfig) produced this warning:
> > > 
> > > drivers/mfd/cs5535-mfd.c: In function 'cs5535_mfd_probe':
> > > drivers/mfd/cs5535-mfd.c:106: warning: format '%d' expects type
> > > 'int', but argument 3 has type 'long unsigned int'
> > > 
> > 
> > Ick, ARRAY_SIZE is unsigned int on x86, unsigned long on x86-64.
> > The patch below fixes this.
> > 
> > 
> > 
> > 
> > From: Andres Salomon <dilinger@queued.net>
> > 
> > ARRAY_SIZE() returns unsigned long on x86-64 (rather than unsigned
> > int); cast it to the desired type to shut gcc up.
> Patch applied, many thanks.
> I'll look at your subdevices patches by the end of this week.
> 

Did you get the chance to look at them?  Also, note that there's an
updated patch for the cs5535-mfd warnings (v2, acked by Randy).
