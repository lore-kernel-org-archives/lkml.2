Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1CNB45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:56:57 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:34689 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1CNB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:56:54 -0400
Message-ID: <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110312173217.GA24981@kroah.com>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <20110311235607.GB15853@elie>
    <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
    <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com>
Date: Mon, 14 Mar 2011 02:56:52 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: "Greg KH" <greg@kroah.com>
Cc: "Jonathan Nieder" <jrnieder@gmail.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "Sage Weil" <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org,
        mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        l@jasper.es
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 74bd734068bee68206891dc8710ce62a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, March 12, 2011 18:32, Greg KH wrote:
> On Fri, Mar 11, 2011 at 08:10:01PM -0600, Jonathan Nieder wrote:
>> Indan Zupancic wrote:
>>
>> > I'm not pushing for any official convention, just what seems good taste.
>>
>> In cases like this, conventions (consistency and best practices) are
>> very important.
>>
>> > Less code added, less bloat. Architecture independent, no need to update
>> > all system call tables everywhere (all archs, libc versions and strace).
>> > Two files changed, instead of 7 (which only hooks up x86).
>>
>> Thanks for explaining.  Those do seem like good reasons to use a ioctl
>> instead of a new syscall.
>
> No, make it a syscall, it's more obvious and will be documented much
> better.

There is no such guarantee. Everyone seems to want to add this new syncfs,
but it's not even defined what it does. "Same as sync, but only on one fs"
is IMHO not good enough, because sync's behaviour is pretty badly documented,
and that's a system call. The sync_file_range argument effects are quite
well defined, on the other hand, unlike sync behaviour. You're right for
ioctls though.

If it has to be added, I'm in favour of adding it as a new sync_file_range
flag option, but wouldn't mind if it was added as some obscure ioctl either.

Do you think that widespread sync() usage is something good? Don't you
think sync(2) should be used as little as possible? And if so, why is
it any different than syncfs?

IMHO we're talking about some system call that shouldn't be used often, and
only rarely in very specific cases. They could use sync(2) with exactly the
same effect, but for performance reasons syncfs() is preferred. So instead
of extremely slow it will be very slow in some cases. Hurray, progress!

Next time you want an async version, and have to add a new systemcall with
a flag argument. So instead of going down that path, please add one with
a flag argument immediately. E.g:

syncfs(const char* path, int fd, int flags);

A NULL path, -1 fd and 0 flags is equal to sync (or something), and then
vary the options. But as it's for a file system, wouldn't it make more
sense to have just a path argument instead of an fd one?

Greetings,

Indan


