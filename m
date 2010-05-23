Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0EWFkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 01:40:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab0EWFkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 01:40:21 -0400
Date: Sat, 22 May 2010 22:38:38 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-Id: <20100522223838.ebca396a.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
	<alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 07:30:01 +0200 Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> Hi all,
> 
> I see that this patch has hit Linus's git, so some questions
> 
> On Wed, May 19, 2010 at 6:49 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Wed, 19 May 2010, Miklos Szeredi wrote:
> >>
> >> One issue I see is that it's possible to grow pipes indefinitely.
> >> Should this be restricted to privileged users?
> >
> > Yes. But perhaps only if it grows past the default (or perhaps "default*2"
> > or similar). That way a normal user could shrink the pipe buffers, and
> > then grow them again if he wants to.
> >
> > Oh, and I think you need to also require that there be at least two
> > buffers. Otherwise we can't guarantee POSIX behavior, I think.
> 
> Is there any documentation (e.g., a man-pages patch) for these changes?
> 
> The argument of the fcntl() operations is expressed in pages. I take
> it that this means that the semantics of the argument will very
> depending on the system page size? So for example, 2 on x86 will mean
> 8192 bytes, but will mean 32768 of ia64? That seems very weird. (And
> what about architectures where the page size is switchable?) Such
> changes in semantics should not be silent for the use, IMO.

Well, there is getpagesize().  But I agree - this interface is just
asking (x86) people to write non-portable code.

otoh, if the arg was in bytes, they'd just hard-code "8192".  They're
clever like that.

But we have gone to some lengths to avoid exposing things like
PAGE_SIZE and HZ in procfs, so it makes sense to take the same approach
to syscalls.

