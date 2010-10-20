Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0JTUyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:54:02 -0400
Received: from www84.your-server.de ([213.133.104.84]:60404 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0JTUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:54:01 -0400
Subject: Re: kfifo must_check warning (+ patch)
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20101020115608.996a9db4.akpm@linux-foundation.org>
References: <20101019151048.ae79bb25.randy.dunlap@oracle.com>
	 <20101019221242.c732e1fa.akpm@linux-foundation.org>
	 <20101020094659.091113f5.randy.dunlap@oracle.com>
	 <20101020193702.584f2c9a@lxorguk.ukuu.org.uk>
	 <20101020115608.996a9db4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Oct 2010 22:09:45 +0200
Message-ID: <1287605385.27545.9.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem should be fixed. I renamed the __kfifo_must_check_helper()
into __kfifo_uint_must_check_helper() and add a new
__kfifo_int_must_check_helper() which is now used for kfifo_alloc().

A kernel linux 2.6.36-rc compiled with gcc 4.4.4 doesn't show the
warning.

There a only two functions which return a int: kfifo_alloc() and
kfifo_init(). The later one does not make use of
__kfifo_int_must_check_helper(), but this could be change if required.

I will send the patch in a separate mail.

Am Mittwoch, den 20.10.2010, 11:56 -0700 schrieb Andrew Morton:
> On Wed, 20 Oct 2010 19:37:02 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Some versions of gcc mysteriously report:
> > > drivers/char/n_gsm.c:1580: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result
> > > 
> > > This warning can be eliminated by using a local variable for the
> > > returned result value, as suggested by Andrew Morton.
> > 
> > But that just hides the bug in the helper surely - the helper has type
> > errors so needs fixing - not this. If you apply this then the underlying
> > bug is just going to get forgotten
> > 
> 
> It won't get forgotten.
> 
> I agree that the warning is probably an artifact of the signedness
> thing.  So for 2.6.36, disabling __kfifo_must_check_helper() will
> suffice.  I'm sure that Stefani will fix up __kfifo_must_check_helper()
> for real for 2.6.37, then we can see if the warning reoccurs.


