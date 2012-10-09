Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2JIXjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:39:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34791 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2JIXj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:39:29 -0400
Date: Wed, 10 Oct 2012 00:39:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Moseley <moseleymark@gmail.com>
Cc: john@feurix.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: linux-audit: reconstruct path names from syscall events?
Message-ID: <20121009233927.GX2616@ZenIV.linux.org.uk>
References: <20110917001215.GA961@zombie.hq.fstein.net>
 <CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:09:18PM -0700, Mark Moseley wrote:

> If you see my recent linux-audit posting, another related thing (at
> least as far as missing relevant information in the logs) is that the
> audit logs are logging pathnames relative to the chroot, instead of
> the pathnames relative to the root of the OS itself. You'd expect a
> process chroot'd to /chroot, accessing (from the perspective of the
> OS) /chroot/etc/password would get logged as /chroot/etc/password but
> is rather logged as /etc/password.
> 
> I don't have a working LXC install handy, but I'd imagine the audit
> subsystem would log relative to the container's / instead of the
> host's / too.

BTW, what makes you think that container's root is even reachable from
"the host's /"?  There is no such thing as "root of the OS itself"; different
processes can (and in case of containers definitely do) run in different
namespaces.  With entirely different filesystems mounted in those, and
no promise whatsoever that any specific namespace happens to have all
filesystems mounted somewhere in it...
