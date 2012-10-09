Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2JIXyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:54:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34878 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JIXyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:54:49 -0400
Date: Wed, 10 Oct 2012 00:54:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Moseley <moseleymark@gmail.com>
Cc: john@feurix.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: linux-audit: reconstruct path names from syscall events?
Message-ID: <20121009235446.GZ2616@ZenIV.linux.org.uk>
References: <20110917001215.GA961@zombie.hq.fstein.net>
 <CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
 <20121009233927.GX2616@ZenIV.linux.org.uk>
 <CAOH1cHmueHV9AiPkNSHXpEKm94nf2XZM9STv=qd7fJ+-n1VK-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOH1cHmueHV9AiPkNSHXpEKm94nf2XZM9STv=qd7fJ+-n1VK-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:47:17PM -0700, Mark Moseley wrote:
> > BTW, what makes you think that container's root is even reachable from
> > "the host's /"?  There is no such thing as "root of the OS itself"; different
> > processes can (and in case of containers definitely do) run in different
> > namespaces.  With entirely different filesystems mounted in those, and
> > no promise whatsoever that any specific namespace happens to have all
> > filesystems mounted somewhere in it...
> 
> Nothing beyond guesswork, since it's been a while since I've played
> with LXC. In any case, I was struggling a bit for the correct
> terminology.
> 
> Am I similarly off-base with regards to the chroot'd scenario?

chroot case is going to be reachable from namespace root, but I seriously
doubt that pathname relative to that will be more useful...

Again, relying on pathnames for forensics (or security in general) is
a serious mistake (cue unprintable comments about apparmor and similar
varieties of snake oil).  And using audit as poor man's ktrace analog
is... misguided, to put it very mildly.
