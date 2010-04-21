Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0DUNjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:39:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36724 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0DUNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:39:38 -0400
Date: Wed, 21 Apr 2010 08:39:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100421133917.GB16326@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alan Cox (alan@lxorguk.ukuu.org.uk):
> > This is a change which must be discussed.  The use of this
> > privilege can be completely prevented by having init remove
> > CAP_GRANT_ID from its capability bounding set before forking any
> > processes.
> 
> Which is a minor back compat issue - but you could start without it and
> allow init to add it.
> 
> It seems a very complex interface to do a simple thing. A long time ago
> there was discussion around extending the AF_UNIX fd passing to permit
> 'pass handle and auth' so you could send someone a handle with a "become
> me" token attached.
> 
> Alan

Hi Alan,

sorry I thought I had cc:d you, bc I was pretty sure you'd have some
neat ideas.  Like this one.

One could try to argue that this makes every linux process susceptible
to a trojan making it grant its userid to other tasks, but of course
that's silly since the trojan could just fork.  Well, what this would
buy the attacker is the ability to sit inconspicuously under his old
userid, holding on to the fd until the admin goes out to coffee before
switching userids.

The other thing is that offhand I think the server can't easily tell
from the socket which user namespace the client is in, as ucred only
has .uid.  Though (1) we might need to create a 'struct puser' analogous
to 'struct pid' for signals anyway, (2) userspace can segragate with
fs or net_ns (if abstract sock), and (3) client in a container
presumably won't be able to authenticate itself to server on the
host anyway.

Ashwin (and Ron), I think this idea will give us the same tools that
the p9auth driver does, perhaps in a more unix-y way.  Would you have
objections, or do you see shortcomings?

Thanks, Alan.

-serge
