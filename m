Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2IUIQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:16:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58963 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab2IUIQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:16:18 -0400
Date: Fri, 21 Sep 2012 09:16:14 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Konstantin Ryabitsev <mricon@kernel.org>, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Helping with backports: linux-next, linux, linux-stable - a few
 enhancements
Message-ID: <20120921081614.GA17547@kroah.com>
References: <CAB=NE6UVZ2HQU27LdkzUFe3of6N1v8YZYVMKsfA+0Wmg5nRBug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6UVZ2HQU27LdkzUFe3of6N1v8YZYVMKsfA+0Wmg5nRBug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 03:45:46PM -0700, Luis R. Rodriguez wrote:
> Greg, Stephen, Konstantin,
> 
> so for the Linux backports project [0] we rely on a few git trees:
> 
>   * linux-next.git
>   * linux-stable.git
>   * linux.git
> 
> The linux.git tree is required for RC releases. The linux-stable.git
> tree for extraversion stable releases, and the linux-next.git tree for
> daily snapshots. There is a trick for stable releases whereby we
> accelerate the integration of pending-stable patches by cherry picking
> them out of linux-next.git if the commit log entry has the
> 'stable@vger.kernel.org' on the commit log, and if the stable patch
> does not apply we require the developers to provide a backport
> compatible port. This trick works swell on linux-next.git for RC
> release given that we can query for rc releases there as linux-next
> carries them but linux-next.git does not carry extra version tags.
> Additionally the requirement of linux.git is only there given that at
> times there are delays between which linux-stable.git will not have an
> RC release on it. I have a way to address all these issues, namely to
> add linux.git as a remote for my local linux-stable tree, and also by
> adding linux-stable as a local remote for my linux-next tree. Now, I
> document how I resolve this for backport package consumers / builders
> but it occurs to me perhaps we can simplify this if we had:
> 
>   * linux-next - pulling in linux-stable packs / tags
>   * a new linux-releases.git - which has both linux.git and
> linux-stable pulled together through a cronjob
> 
> Would this be reasonable to accommodate to help ease of use or shall
> we just live with folks having to do the remote / local remote hacks?

I pull the linux.git tree into linux-stable.git every few -rc releases,
and as it's based on linux.git, it's really not a big deal.

I don't see how pulling linux-stable into linux-next really helps anyone
out, linux-stable is so far behind what is in linux-next it's not funny.

But, if you really want it all in a single tree, can't you just do this
with a few 'remote' markings in your git configuration file for the repo
and do it locally if you want to?

Otherwise I don't see the real question here.

confused probably due to a bad case of jet lag,

greg k-h
