Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2DYOxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:53:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab2DYOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:53:34 -0400
Date: Wed, 25 Apr 2012 16:52:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425145239.GA21386@redhat.com>
References: <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120425030659.GE6871@ZenIV.linux.org.uk> <20120425123746.GA15560@redhat.com> <20120425125042.GF6871@ZenIV.linux.org.uk> <20120425130329.GA16413@redhat.com> <20120425133238.GG6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425133238.GG6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Al Viro wrote:
>
> Point...  Still, since we are talking about an arbitrary wide window (the
> damn thing is waiting for signals to arrive, after all) this doesn't
> sound good;
> ...
> IMO it's
> a QoI problem at the very least.

and looks confusing, agreed.

> As for SA_RESTART/!SA_RESTART mixes, if SA_RESTART comes first we should
> just take that restart and pretend that the second signal has arrived at
> the very beginning of handler, I think.

Yes. My point was, this confuses the user-space developers too. And this
case is equally unclear to me wrt should we (at least try to) change this
or not.

Oleg.

