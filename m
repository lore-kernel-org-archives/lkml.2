Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2LVCyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:54:19 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:57712 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab2LVCyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:54:15 -0500
Date: Sat, 22 Dec 2012 02:54:14 +0000
From: Eric Wong <normalperson@yhbt.net>
To: "Junchang(Jason) Wang" <junchang.wang@yale.edu>
Cc: Andreas Voellmy <andreas.voellmy@yale.edu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: epoll with ONESHOT possibly fails to deliver events
Message-ID: <20121222025414.GA6217@dcvr.yhbt.net>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu>
 <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu>
 <20121213093242.GA25436@dcvr.yhbt.net>
 <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu>
 <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
 <20121220213210.GA22655@dcvr.yhbt.net>
 <CAErQho6bf+y+7dwtP4sKjNGsjLdDm8aBo4A6KagZHgcRT=KMWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErQho6bf+y+7dwtP4sKjNGsjLdDm8aBo4A6KagZHgcRT=KMWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Junchang(Jason) Wang" <junchang.wang@yale.edu> wrote:
> We still believe this is a bug in epoll system even though we can't
> prove that so far. Both Andi and I are very interested in this problem
> and helping you experts solve this it. Just let us know if we can
> help.

I'm just another epoll user, definitely not an expert.  Hopefully
somebody else can figure this out, because I'm unable to reproduce the
problem with your code and I haven't spotted any bugs from reading
through the kernel.

Curious, I also have a multi-threaded HTTP server which is a little
similar (multi-threaded, 2 epoll descriptors (only one epoll is heavily
used).  I run it on 2/4-core systems and haven't hit issues with epoll.

If you want to test, it should be easy to build from tarball:

  http://bogomips.org/cmogstored/files/cmogstored-1.0.0.tar.gz
  configure && make
  ./cmogstored --httplisten=8080 --docroot=/path/to/whatever

More info here: http://bogomips.org/cmogstored/README
git clone http://bogomips.org/cmogstored.git
