Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0HSPhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:37:05 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0HSPhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:37:02 -0400
Subject: Re: kernel-doc problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100819083028.6509ab3e.rdunlap@xenotime.net>
References: <1282224019.4507.3.camel@jlt3.sipsolutions.net>
	 <20100819083028.6509ab3e.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 17:37:01 +0200
Message-ID: <1282232221.4507.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 08:30 -0700, Randy Dunlap wrote:

> > --- here's the file ---
> > /**
> >  * fn - test
> >  *
> >  * @a: This is just a non-sense and totally useless dummy function
> >  *	argument: it has absolutely no effect.
> >  */
> > void fn(int a)
> > {
> > }
> 
> Colons (':') are bad.  They cause a section instance.

Yeah, that's what I found.

> I don't know how to fix it (inside kernel-doc or docproc or xmlto or wherever).
> Sometimes I change colon to "--" or "." or something that makes some sense,
> but colon is still the better choice if it would work.

Ok.

Actually, I can think of something. When we have a line that starts with
this kind of pattern, assume that the next line is a continuation of it
and do not pattern match it, unless there was a blank line. I guess that
needs a special case for @...: though.

johannes

