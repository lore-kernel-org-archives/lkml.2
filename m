Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1EGHFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 03:05:22 -0400
Received: from mail.avalus.com ([89.16.176.221]:34655 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1EGHFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 03:05:20 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 03:05:20 EDT
Date: Sat, 07 May 2011 07:58:28 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        linux-fsdevel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: [PATCH 0/7] Network namespace manipulation with file
 descriptors
Message-ID: <3A54AB469A0294933EAC2257@nimrod.local>
In-Reply-To: <m1tyd7p7tq.fsf@fess.ebiederm.org>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--On 6 May 2011 19:23:29 -0700 "Eric W. Biederman" <ebiederm@xmission.com> 
wrote:

> This patchset addresses the user interface limitations by introducing
> proc files you can open to get file descriptors that keep alive and
> refer to your a tasks namespaces.  Those file descriptors can be passed
> to the new setns system call or the NET_NS_FD argument in netlink
> messages.

This is conceptually very interesting. I am one of those people you
describe with a routing daemon (or more accurately a wrapper around
existing daemons) that does the unshare() and keeps the network
alive. It also has a control socket etc.

You say:
> This addresses three specific problems that can make namespaces hard to
> work with.
> - Namespaces require a dedicated process to pin them in memory.
> - It is not possible to use a namespace unless you are the child
>   of the original creator.
> - Namespaces don't have names that userspace can use to talk about
>   them.

At least for me, the best way to solve the second blob would be to
be able to unshare to an existing namespace. That way I would be able
to run a daemon (without modification) in a pre-existing namespace.
The user interface here would just be an option to 'unshare'. I
don't think your patch allows this, does it? Right now I'm effectively
doing that by causing the pid concerned to fork() and do my bidding,
but that is far from perfect.

As a secondary issue, ever without your patch, it would be really
useful to be able to read from userspace the current network namespace.
(i.e. the pid concerned, or 1 if not unshared). I would like to
simply modify a routing daemon's init script so it doesn't start
if in the host, e.g. at the top:
  [ `cat /proc/.../networknamespace` eq 1 ] && exit 0

-- 
Alex Bligh
