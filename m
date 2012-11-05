Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2KEUDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:03:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34536 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2KEUDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:03:50 -0500
Date: Mon, 5 Nov 2012 21:03:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, david@lang.hm,
        Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        ????????? Yang Su Li <suli@cs.wisc.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121105200348.GB15821@xo-6d-61-c0.localdomain>
References: <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
 <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
 <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
 <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
 <20121025060231.GC9860@thunk.org>
 <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
 <20121025140327.GB13562@thunk.org>
 <alpine.DEB.2.02.1210251048280.8519@asgard.lang.hm>
 <20121025182948.GB16257@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025182948.GB16257@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2012-10-25 14:29:48, Theodore Ts'o wrote:
> On Thu, Oct 25, 2012 at 11:03:13AM -0700, david@lang.hm wrote:
> > I agree, this is why I'm trying to figure out the recommended way to
> > do this without needing to do full commits.
> > 
> > Since in most cases it's acceptable to loose the last few chunks
> > written, if we had some way of specifying ordering, without having
> > to specify "write this NOW", the solution would be pretty obvious.
> 
> Well, using data journalling with ext3/4 may do what you want.  If you
> don't do any fsync, the changes will get written every 5 seconds when
> the automatic journal sync happens (and sub-4k writes will also get

Hmm. But that would need setting journalling mode per-file, no?

Like, make it journal data for all the databases, but keep normal mode
for rest of system...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
