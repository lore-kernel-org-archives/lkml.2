Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2ECNUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:20:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2ECNUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:20:36 -0400
Date: Thu, 3 May 2012 14:20:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
Message-ID: <20120503132025.GO6871@ZenIV.linux.org.uk>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com>
 <20120430114410.GB28308@thunk.org>
 <87fwbhhdp2.fsf@skywalker.in.ibm.com>
 <20120503130707.GF18002@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503130707.GF18002@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:07:07AM -0400, Ted Ts'o wrote:
> On Thu, May 03, 2012 at 01:57:21PM +0530, Aneesh Kumar K.V wrote:
> > 
> > fstat won't work, but fstatat with an empty path name would work. O_PATH
> > descriptors are suppose to be used as "location only descriptors". 
> > We then extended the *at syscalls to work with EMPTY pathnames so that
> > O_PATH descriptors can be used with readlink, fchownat and fstatat().
> > This was done to enable us to do these operation on symlinks.
> > (65cfc6722361570bfe255698d9cd4dccaf47570d)
> 
> Could you define explicitly what you mean by "EMPTY" pathnames?

"".  Normally yields -EINVAL when used as a relative pathname in ...at()
syscalls.
