Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1FMS4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:56:17 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38856 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FMS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:56:14 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jun 2011 14:56:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=d0q1ti92rJOrthW2rErqZmxjB3rgSUS/dnoSz8iUu33smhxThlmoodWMBZzPPjmZC1
         6sgKFOHX0ydT9lA3bm8HafALqXv5VkO0atV1KOF1r00biKdcsUdo4braBRsrtNM8Yhmb
         sLIsZE6etnux7CgK1TE6xL4/JOxxZpN+kXAkY=
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
	<20110609123843.77153b27.akpm@linux-foundation.org>
	<877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl>
Date: Mon, 13 Jun 2011 20:48:58 +0200
In-Reply-To: <21324.1307677721@jrobl> (J. R. Okajima's message of "Fri, 10 Jun
	2011 12:48:41 +0900")
Message-ID: <871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

> Miklos, thanks forwarding.
> Here I try replying after summerising several messages.

Okajima-san, thanks for replying.

> Feature sets:
> ----------------------------------------
> If I remember correctly, Miklos has mentioned about it like this.
> - overlayfs provides the same feature set as UnionMount.
> - but its implementation is much smaller and simpler than UnionMount.
>
> I agree with this argument (Oh, I have to confess that I don't test
> overlayfs by myself). But it means that overlayfs doesn't provide some
> features which UnionMount doesn't provide. I have posted about such
> features before, but I list them up again here.
> - the inode number may change silently.
> - hardlinks may corrupt by copy-up.
> - read(2) may get obsolete filedata (fstat(2) for metadata too).
> - fcntl(F_SETLK) may be broken by copy-up.
> - unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
>   open(O_RDWR).

Good summary of the unPOSIXy behavior in overlayfs/union-mounts.  Some
of this is already described in Documentation/filesystems/overlayfs.txt,
and I'll add the rest.

> Later I noticed one more thing. /proc/PID/{fd/,exe} may not work
> correctly for overlayfs while they would work correctly for
> UnionMount. In overlayfs, they refer to the file on the real filesystems
> (upper or lower) instead of the one in overlayfs, don't they? If so, I
> am afraid a few applications may not work correctly, particularly
> start-stop-daemon in debian.

You are right, proc symlinks work in unexpected ways in overlayfs and
this is not documented yet either.

> Approaches in overlayfs:
> ----------------------------------------
> This is also what I have posted, but I write again here since I don't
> have any response.
> I noticed overlayfs adopts overriding credentials for copy-up.
> Although I didn't read about credintials in detail yet, is it safe?
> For example, during copy-up other thread in the same process may gain
> the higher capabilities unexpectedly? Signal hander in the process
> too?

The credentials are gained only by one task for the duration of the
operation.  It's not possible to use this to gain elevated privileges
for other tasks or by signal handlers.


> Misc.
> ----------------------------------------
> Miklos Szeredi:
>> I think the reason why "aufs" never had a real chance at getting merged
>> is because of feature creep.
>
> What is "feature creep"?

http://en.wikipedia.org/wiki/Feature_creep

Thanks,
Miklos
