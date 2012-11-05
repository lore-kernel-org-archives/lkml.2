Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2KEWFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:05:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:59490 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2KEWFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:05:05 -0500
Date: Mon, 5 Nov 2012 17:04:40 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        ????????? Yang Su Li <suli@cs.wisc.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121105220440.GB25378@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>, david@lang.hm,
	Nico Williams <nico@cryptonector.com>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	????????? Yang Su Li <suli@cs.wisc.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
References: <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
 <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
 <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
 <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
 <20121025060231.GC9860@thunk.org>
 <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
 <20121025140327.GB13562@thunk.org>
 <alpine.DEB.2.02.1210251048280.8519@asgard.lang.hm>
 <20121025182948.GB16257@thunk.org>
 <20121105200348.GB15821@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105200348.GB15821@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:03:48PM +0100, Pavel Machek wrote:
> > Well, using data journalling with ext3/4 may do what you want.  If you
> > don't do any fsync, the changes will get written every 5 seconds when
> > the automatic journal sync happens (and sub-4k writes will also get
> 
> Hmm. But that would need setting journalling mode per-file, no?
> 
> Like, make it journal data for all the databases, but keep normal mode
> for rest of system...

You can do that, using "chattr +j file.db".  It's apparently not a
well known feature of ext3/4....

						- Ted
