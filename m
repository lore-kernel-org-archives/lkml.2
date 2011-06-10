Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1FJDz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:55:26 -0400
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:37203 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1FJDzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:55:24 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jun 2011 23:55:24 EDT
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
In-Reply-To: <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu> <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 10 Jun 2011 12:48:41 +0900
Message-ID: <21324.1307677721@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos, thanks forwarding.
Here I try replying after summerising several messages.

Feature sets:
----------------------------------------
If I remember correctly, Miklos has mentioned about it like this.
- overlayfs provides the same feature set as UnionMount.
- but its implementation is much smaller and simpler than UnionMount.

I agree with this argument (Oh, I have to confess that I don't test
overlayfs by myself). But it means that overlayfs doesn't provide some
features which UnionMount doesn't provide. I have posted about such
features before, but I list them up again here.
- the inode number may change silently.
- hardlinks may corrupt by copy-up.
- read(2) may get obsolete filedata (fstat(2) for metadata too).
- fcntl(F_SETLK) may be broken by copy-up.
- unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
  open(O_RDWR).

Later I noticed one more thing. /proc/PID/{fd/,exe} may not work
correctly for overlayfs while they would work correctly for
UnionMount. In overlayfs, they refer to the file on the real filesystems
(upper or lower) instead of the one in overlayfs, don't they? If so, I
am afraid a few applications may not work correctly, particularly
start-stop-daemon in debian.

I agree that overlayfs is simpler than aufs, because aufs has many
features which Miklos thinks unnecessary. But most features in aufs are
popped out of many reports or requests from users for a loooong time. I
don't think they are unnecessary.

By the way how looong history does aufs have?
It is long enough to allow major distibutors to make obsoleted and
not-maintained version of aufs distributed. I am tired of replying and
describing "your version is obsoleted. ask your distributor to update
aufs or you need to get latest version" or something. I hope you would
know aufs is released every Monday basically (currently I stopped
updating for a few months though).


Approaches in overlayfs:
----------------------------------------
This is also what I have posted, but I write again here since I don't
have any response.
I noticed overlayfs adopts overriding credentials for copy-up.
Although I didn't read about credintials in detail yet, is it safe?
For example, during copy-up other thread in the same process may gain
the higher capabilities unexpectedly? Signal hander in the process too?


Future of overlayfs:
----------------------------------------
I don't know what it will be after merging.
But to support the missing features above, I am afraid overlayfs will
grow by adding them. How large and complicated it will be? As current
aufs or much simpler? Nobody knows except the one who have ever think
how to implement these features.

I remember there was a post saying he can live without fully supported
hardlinks. There may exist people who says those missing features are
less important even if any problem arise. They may just restart their
system and forget everything. It is ok as long as he can be happy. They
might use overlayfs for LiveCD/DVD/Flash only.
But I believe there exists people who think those features important and
necessary. They might use layering for servers or long live systems to
provide their services to others.


Misc.
----------------------------------------
Miklos Szeredi:
> I think the reason why "aufs" never had a real chance at getting merged
> is because of feature creep.

What is "feature creep"?
Does it mean that aufs has many features and they make it much slower as
an insect creeps? If so, I'd suggest you read the aufs manual and try
some options to make it faster by skipping several features. If I
remember correctly, I have not received such report saying aufs is slow
from aufs users. So I'd request you to post some comparision tests
results if you have.

Aufs was rejected merging because LKML people decided that linux
mainline will never include the union-type-filesystem but will include
the union-type-mount (eg. UnionMount).
See http://marc.info/?l=linux-kernel&m=123938317421362&w=2


Michal Suchanek:
> No implementation will satisfy all needs. There is always some
> compromise between availability (userspace/in-tree/easy to patch in)
> feature completeness (eg. AuFS is not so easy to forward-port to new
> kernels but has numerous features) performance, reliability.

Not so easy?
While I stopped updating aufs2 just before 2.6.39 (because I simply have
no time), I think it is easy for aufs to support 2.6.39 or 3.0.
Would you tell me what is so difficult?


Sorry for long mail and broken English
J. R. Okajima
