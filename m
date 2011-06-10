Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab1FJWrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:47:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52299 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab1FJWrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:47:39 -0400
Date: Fri, 10 Jun 2011 23:47:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Why is CONFIG_FHANDLE an option??
Message-ID: <20110610224738.GB11521@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net>
 <20110610223955.GA11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610223955.GA11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 11:39:55PM +0100, Al Viro wrote:

> Why not?  Software needs to test *anyway*, since it might run on earlier
> kernels.  And "does that syscall return -ENOSYS" is self-documenting,
> while "is the version higher than $MAGIC_NUMBER" is *not*.  Especially since
> there's such thing as backports.
> 
> If you need to check that syscall is there, _check_ _it_.  Don't breed
> dependencies on version numbers.

PS: we have BSD_PROCESS_ACCT doing pretty much the same kind of thing.
And SYSVIPC.  And POSIX_MQUEUE.  And there's nfsservctl(2), also
config-dependent.  And eventfd(2), and inotify syscalls, etc.

There is such thing as optional system calls.  Always had been.  Deal
with that...
