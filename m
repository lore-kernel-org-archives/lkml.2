Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1LTVX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:23:57 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47077 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab1LTVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:23:51 -0500
X-Sasl-enc: mYxddaoOGMzN9i8hsWLV/4kO6135wYQKcaDmJB357VeZ 1324416230
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
Date: Tue, 20 Dec 2011 16:23:30 -0500
In-Reply-To: <m1ehw1mlcf.fsf@fess.ebiederm.org>
References: <1323280461.10724.13.camel@lenny>
	 <20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	 <20111212231149.GA16408@hallyn.com> <1323982580.31563.15.camel@lenny>
	 <m1k45xyreb.fsf@fess.ebiederm.org> <1324224103.21713.26.camel@lenny>
	 <m1ehw1mlcf.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324416210.25566.35.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-18 at 16:55 -0800, Eric W. Biederman wrote:

> I expect by the time this makes it to "out of the box" experiences on
> enterprise distros, useradd and friends will be giving out 1000 or so uids
> to new accounts.

Hmm...how would that work?  Would it be something that would happen at
PAM time, like a module that looks up some file in /etc and says "OK
this uid gets this range" and uploads that to the kernel? 

This whole idea of a normal uid getting *other* slave uids is cool but
scary at the same time.  So much infrastructure in what I think of as
"General Purpose Linux"[1] is built up around a uid - resource
restrictions and authentication for example.

I guess as long as we're sure that all cases where a "uid" crosses a
user namespace (say socket credentials) and appears as the right thing,
it may be secure.

> I think the user namespace will do what you need. Certainly it appears
> that everything in your example binary will be allowed by the time it is
> done.

That's cool, I will keep an eye on what you guys are doing.  Looks like
the containers list on linuxfoundation.org is the right one to follow?

[1] The code that's shared between RHEL and Debian roughly between the
kernel and GNOME, discarding the pointless "packaging" differences


