Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2KHN0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:26:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35542 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755541Ab2KHN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:26:04 -0500
Message-ID: <1352381151.9901.5.camel@joe-AO722>
Subject: Re: [RFC PATCH] checkpatch: Add a --strict test for macro argument
 reuse
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Thu, 08 Nov 2012 05:25:51 -0800
In-Reply-To: <20121106120027.94648924.akpm@linux-foundation.org>
References: <1352198139.16194.21.camel@joe-AO722>
	 <20121106120027.94648924.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-06 at 12:00 -0800, Andrew Morton wrote:
> On Tue, 06 Nov 2012 02:35:39 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > Add a test for reuse of macro arguments to highlight
> > any possible side-effects from this reuse.
> > 
> > Avoid this check on token name pasting and when the
> > argument is used in a typeof or a __builtin.
> 
> Does this mean that if I do
> 
> 	#define foo(a) bar(a, a)
> 
> that checkpatch will not generate a warning unless I give it
> "--strict"?  If so: whaaah!  I want that warning to come out by
> default.

Well, that was the intent, yes.

I wanted to avoid a bunch of people "improving" simple macros
with a normal checkpatch run on files like include/linux/kernel.h

> Not being totally lazy, I tried it myself but my perl v5.10.1 had
> conniptions over this patch:

Because I had originally used ERROR but decided to use the
incorrect form of CHECK instead of CHK when I submitted the
patch.  Sorry.

Anyway, do try it on include/linux files with -f and see if
you think it's really appropriate to have the thing report
this type of error.

Dunno.  Maybe it's appropriate to warn on .diff/.patch files
but only emit the message  on checkpatch -f --strict uses.

I generally don't like different behavior based on runtime
input.  Shrug.  Who knows what's right here.

