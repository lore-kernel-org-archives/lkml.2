Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab2AMStY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:49:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2AMStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:49:19 -0500
Date: Fri, 13 Jan 2012 10:49:13 -0800
From: Tejun Heo <htejun@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        david.henningsson@canonical.com, smcnam@gmail.com,
        gmane@colin.guthr.ie, jamescaldwell1@gmail.com,
        s.maddox@lantizia.me.uk, mszeredi@suse.cz
Subject: Re: [PATCH 2/2] cuse: implement memory mapping
Message-ID: <20120113184913.GB11112@google.com>
References: <1326474399-27278-1-git-send-email-miklos@szeredi.hu>
 <1326474399-27278-3-git-send-email-miklos@szeredi.hu>
 <CA+55aFy7xLkMThg8+G=e7v7x7WaHSkLWGRiRF8hCq4WEUHxymw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy7xLkMThg8+G=e7v7x7WaHSkLWGRiRF8hCq4WEUHxymw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Fri, Jan 13, 2012 at 10:19:50AM -0800, Linus Torvalds wrote:
> On Fri, Jan 13, 2012 at 9:06 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > From: Tejun Heo <htejun@gmail.com>
> >
> > This implements memory mapping of char devices.
> 
> I don't think this is how you want to do it.
> 
> It seems to maintain a page list of its own, and do the magic page
> fault etc behavior. Which to me smells like a really bad design.
> 
> I would expect that what you actually want to do is to expose it as a
> shared mmap, and depend on all the normal shmem support. Is there any
> reason not to do that?
> 
> I guess you don't generally have big mappings, so an argument like
> "that way you can page out pages etc" may not strike you as a very
> strong argument, but I'd still prefer to at least see that approach
> explored. Hmm?

The patch is years old and the original implementation had different
requirements (it mapped the same pages in the client's and server's
address spaces instead of using notifications).  I don't really
remember the details but I tried to use shmem pretty hard but
couldn't.  I *think* it was about having to accept random mapping
offset.  ISTR shmem implementation wasn't too happy with randomish
high mapping offset and I couldn't shift the mapping offset due to the
direct mapping requirement (again, memory is quite fuzzy).

With notification based implementation, it might be able to just shift
the mapping offset and use shmem.  Miklos, what do you think?

Thanks.

-- 
tejun
