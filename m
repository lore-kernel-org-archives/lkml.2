Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2AXA0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:26:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2AXA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:26:04 -0500
Date: Mon, 23 Jan 2012 18:25:55 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, sukadev@linux.vnet.ibm.com,
        Andy Whitcroft <apw@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124002555.GA29534@sergelap>
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

Quoting Linus Torvalds (torvalds@linux-foundation.org):
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
> 
> Or did I entirely misunderstand the problem?
> 
>                       Linus

I like it.

The only place that *might* be a problem is if initramsfs does a devpts
mount, and later init blindly mounts tmpfs on /dev and mounts a new
devpts.  But it seems unlikely there would be any open pty's so it
shouldn't really matter.

I could go ahead and test that, say, ubuntu and fedora systems boot fine
with this change.  But of course I can't be sure there is no userspace
out there that won't cope...

-serge
