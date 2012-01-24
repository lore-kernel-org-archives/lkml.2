Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2AXA0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:26:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2AXA0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:26:34 -0500
Date: Tue, 24 Jan 2012 00:26:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Dave Hansen <haveblue@us.ibm.com>, sukadev@linux.vnet.ibm.com,
        Andy Whitcroft <apw@canonical.com>, Matt Helsley <matthltc@us.ibm.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124002620.GI23916@ZenIV.linux.org.uk>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 04:13:49PM -0800, Linus Torvalds wrote:
> On Mon, Jan 23, 2012 at 4:05 PM, Serge Hallyn
> <serge.hallyn@canonical.com> wrote:
> >
> > I've been playing for the last week with ways to fix this, and in the
> > end I can see two ways.
> 
> How about a third way:
> 
>  - make "newinstance" mandatory (and "-o newinstance" is a no-op) and
> forget about the whole issue.
> 
>  - if you really want to remount the old global one, you have to use a
> bind mount of that original mount instead.
> 
> There may be some subtle reason why the above is totally broken and
> just fundamnetally wouldn't work, and breaks all existing setups, but
> maybe it's worth at least discussing as an option?

Hell knows...  That's certainly what I would have prefered, but I wonder
about existing practices along the lines of "mount it in chroot jail
from inside that jail" (as opposed to mount --bind /dev/pts /jail/dev/pts
while preparing it).

Posted patch is too ugly to live and as for the new kind of namespace...
yuck.  We already have far too many :-/
