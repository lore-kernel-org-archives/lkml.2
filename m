Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2DZIcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:32:52 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:55252 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2DZIct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:32:49 -0400
Message-ID: <4F99082F.1040902@msgid.tls.msk.ru>
Date: Thu, 26 Apr 2012 12:32:47 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Meyer <thomas@m3y3r.de>, stable@kernel.org,
        autofs@vger.kernel.org
Subject: Re: [PATCH] unbreak automount daemon after fixing autofs5 ABI
References: <1335421594-10499-1-git-send-email-mjt@msgid.tls.msk.ru> <1335428498.6702.33.camel@perseus.themaw.net>
In-Reply-To: <1335428498.6702.33.camel@perseus.themaw.net>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.04.2012 12:21, Ian Kent wrote:
> On Thu, 2012-04-26 at 10:26 +0400, Michael Tokarev wrote:
[]
>> Change 499f286dc02cde6b tries to fix the original interface
>> bug for 32bit userspace running on 64bit kernel.  But the
>> issue is that autofs5 already has a workaround for it, so
>> the end result is that the two (kernel & user) disagree
>> again.  "Fix" this by applying the in-kernel fix only if
>> the process is not named "automount" -- which is how autofs5
>> daemon is named.
> 
> No, you cannot be sure the autofs binary is named automount.

Well, I checked several distributions, all have the binary named
this way.  Yes a user can rename it and it will break again, but
it is at least better than now when it does not work at all.  And
yes it is messy, just like current situation already is.

> Not only that, this approach makes an unpleasant change even more
> unpleasant.
> 
> I still think that my original proposed patches were the better approach
> to handling this problem.
> 
> My recommendation was that the major autofs kernel protocol version be
> bumped and a packed structure used from that version on. That allows
> user space to request that protocol version for communication at mount
> time. If systemd doesn't want to support earlier protocol versions then
> it can complain, instructing the user to update to a later kernel.

This is exactly what I was proposing when I started my thread about
3.0.24 autofs breakage -- to _revert_ the in-kernel fix and introduce
a new interface (or variation thereof, in means of a new mount option
or something).  This way, breakage and mess are both minimal.

Note that a major protocol changes aren't really needed, just a single
mount option, which uses a right size of the structure.  Unless at the
same time you want to change something else.

> I understand why that proposal was not well accepted but the fact

But I don't understand this ;)

> remains, I did make a mistake and I did chose to work around it in user
> space rather than cope with the pain at the time. In hind site that may
> have been the wrong thing to do but that's history. So I believe the
> most sensible thing to do now is to take the approach that minimizes
> breakage.

No one complains to you now about the history, and it is not relevant
now already, as we do have what we have.

And yes I 100% agree that reverting that "fix" change in kernel and
introducing a more sane "slightly new" interface is the way to go.

Thank you!

/mjt
