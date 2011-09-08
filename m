Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1IHXzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:55:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42692 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1IHXy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:54:59 -0400
Date: Thu, 8 Sep 2011 22:54:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>, autofs@linux.kernel.org
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
Message-ID: <20110908215425.GW2203@ZenIV.linux.org.uk>
References: <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
 <1315281208.3210.26.camel@perseus.themaw.net>
 <87mxeixfaq.fsf@tucsk.pomaz.szeredi.hu>
 <1315319903.3210.51.camel@perseus.themaw.net>
 <87ipp5y912.fsf@tucsk.pomaz.szeredi.hu>
 <1315485406.3476.9.camel@perseus.themaw.net>
 <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFy3VN2Y-oadFUMdCaBVQtPT9Ae3fDQCw5vHfA6UvH8GiA@mail.gmail.com>
 <20110908195043.GV2203@ZenIV.linux.org.uk>
 <CA+55aFzfXOi2xk1JVnTTzQPzoNH+iQkhtpT6cVEz+D7si8MAfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzfXOi2xk1JVnTTzQPzoNH+iQkhtpT6cVEz+D7si8MAfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 01:19:49PM -0700, Linus Torvalds wrote:

> >> I'm inclined to apply the patch as a regression fix, but I'll let this
> >> thread try to convince me for another day..
> >
> > IIRC, that matches traditional SunOS behaviour and it actually does make
> > sense; you want wildcard expansion and ls -l to be doable even when there's
> > a stuck NFS server. ?IOW, non-triggering lstat(2) is a matter of usability...
> 
> non-triggering lstat() isn't the issue, afaik. We never trigger on lstat.
> 
> nontriggering *stat()* is the issue. We didn't *use* to trigger on
> stat() either. Now in 2.6.38+ we do.

Yes.  Again, IIRC that's what SunOS implementation had been doing all along;
I think the reason was that stat()+open()+fstat() getting different results
for stat and fstat would spook quite a few programs, but I could be easily
wrong on that.

I've no strong preferences for or against that change; to be honest, the set
of situations when automount triggers always left an impression of voodoo
balancing between usability (== not triggering it too much, lest we end up
with stuck boxen and unhappy admins) and not breaking expectations of userland
(e.g. stat/open/fstat issue)...
