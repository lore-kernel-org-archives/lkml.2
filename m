Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966719Ab2EOUMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:12:44 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43757 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225Ab2EOUMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:12:41 -0400
Message-ID: <1337112446.20904.50.camel@falcor>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 15 May 2012 16:07:26 -0400
In-Reply-To: <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
	 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
	 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051520-7282-0000-0000-0000090E5F98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 15:42 -0400, Eric Paris wrote:
> On Tue, May 15, 2012 at 2:41 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, May 15, 2012 at 10:19 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >>  - move the whole call to security_file_mmap() to outside the
> >> mmap_sem, and test the *suggested* address (which is not the same as
> >> the final address)
> >
> > Actually, I think I have a simpler approach.
> >
> > We already actually have two *different* security_file_mmap() calls:
> > it's just that currently the difference is shown by the last argument
> > to the function ("addr_only").
> 
> I'm the one who introduced that bit of horrific.  I originally did it
> the way you describe and someone (it was a long time ago, and I think
> it was Ted Tso, but I am probably very very wrong on that) ask me to
> tack it on the end like this.  I'd be very happy with the split you
> describe.
> 
> I'd rather not, however, move the address call site like you described
> above, as I don't want to allow NULL + ~MAP_FIXED to be tested until
> it has been resolved to a real address.  I don't want someone to find
> a way to get the kernel to choose 4096 and avoid the check....

If the security_file_mmap() moves to before taking the mmap_sem and the
new security_mmap_addr() hook would be at the current
security_file_mmap() location, I don't see the problem.  The addr test
would remain in the same place.

> Mimi, would you like to do this (slightly) larger change?  Should I?

np, I'll make the changes.

Mimi

