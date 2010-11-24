Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0KXOdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:33:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36375 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0KXOdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:33:19 -0500
Subject: Re: [PATCH] generic-ipi: add lock context annotations
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1290608996.1675.2.camel@leonhard>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
	 <1290430003.2072.101.camel@laptop> <1290482390.1857.26.camel@leonhard>
	 <4CEB8034.80400@fusionio.com> <20101123094016.GC8882@bicker>
	 <1290576280.1690.13.camel@leonhard>  <20101124054305.GP1522@bicker>
	 <1290608996.1675.2.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 15:33:34 +0100
Message-ID: <1290609214.2072.476.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 23:29 +0900, Namhyung Kim wrote:
> 2010-11-24 (수), 08:43 +0300, Dan Carpenter:
> > On Wed, Nov 24, 2010 at 02:24:40PM +0900, Namhyung Kim wrote:
> > > 2010-11-23 (화), 12:40 +0300, Dan Carpenter: 
> > > > On Tue, Nov 23, 2010 at 09:49:56AM +0100, Jens Axboe wrote:
> > > 
> > > I tried to annotate declations in include/linux/smp.h but it didn't work
> > > well. Maybe that's what we need to fix the sparse?
> > > 
> > 
> > It worked for me earlier when I tested it.  Just add the exact same
> > annotations that you added to the .c file.
> > 
> > regards,
> > dan carpenter
> > 
> 
> OK. You mean annotating both .c and .h, right? Will send v2 soon.

Aside from complain, do these sparse annotations ever catch a bug?

I don't particularly like the __acquire() and __release() tags, but
could possibly live with them when they only need to be in headers, but
the __cond_lock() crap is just revolting.
