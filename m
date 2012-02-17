Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2BQPTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:19:08 -0500
Received: from r00tworld.com ([212.85.137.150]:39260 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2BQPTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:19:06 -0500
X-Greylist: delayed 3309 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Feb 2012 10:19:06 EST
From: pageexec@freemail.hu
To: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 17 Feb 2012 15:23:23 +0200
MIME-Version: 1.0
Subject: Re: Add overflow protection to kref
Reply-to: pageexec@freemail.hu
CC: Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        spender@grsecurity.net
Message-ID: <4F3E62DB.6956.CF97716@pageexec.freemail.hu>
In-reply-to: <20120217014008.GA18763@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>, <20120217010624.GA6541@outflux.net>, <20120217014008.GA18763@kroah.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Fri, 17 Feb 2012 15:23:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Feb 2012 at 17:40, Greg KH wrote:

> > A quick search gives me:
> > CVE-2005-3359: https://bugzilla.redhat.com/show_bug.cgi?id=175769
> > CVE-2006-3741: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b8444d00762703e1b6146fce12ce2684885f8bf6
> 
> Neither of those are kref issues, just bugs with other types of
> counting things.

kref is just one of the many users of the atomic type that use it for refcounting.
and kref users are no more immune to programming mistakes that can result in overflow
than direct atomic users.

> Again, I don't know of any kref overflows that have ever happened, so
> trying to "protect" this type of thing, seems odd to me.

well, do you analyze all bugreports/patches/etc for this problem? even if you did
it's easy to miss them because kref_put has so many wrappers around it whose uses
would also have to be checked for. anyway, a very lightweight grep in the git log
turned up these (i spent half a minute on it only, don't expect a flood ;):

14660ccd599dc7bd6ecef17408bd76dc853f9b77
ece84241b93c4693bfe0a8ec9a043a16d216d0cd
b65d457913d1c0644394287d5d834373f42fb99a
94735ec4044a6d318b83ad3c5794e931ed168d10

