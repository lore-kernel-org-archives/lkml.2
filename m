Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1CLBxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:53:40 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45836 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1CLBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:53:37 -0500
Message-ID: <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110311235607.GB15853@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <20110311235607.GB15853@elie>
Date: Sat, 12 Mar 2011 02:53:35 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: "Jonathan Nieder" <jrnieder@gmail.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Sage Weil" <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
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
X-Scan-Signature: 1f72ff50073f138f9668c095d6f579a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, March 12, 2011 00:56, Jonathan Nieder wrote:
> Indan Zupancic wrote:
>
>> If there still is a good reason to implement this, please don't add it
>> as a new system call, but add it to sync_file_range(), as that seems
>> the best place for odd file synchronisation operations.
>
> I have no strong preference about how this is added (and in fact I'm
> quite ignorant about the usual conventions), but:

I'm not pushing for any official convention, just what seems good taste.

>  - as a sysadmin, it really _would_ be nice to be able to say
>    "sync /usr" to sync /usr;

This is independent of the implementation.

>  - the existing functionality of sync_file_range is about controlling
>    writeback behavior for files, not mounts.

True, but what happens when you sync a mount? In the end it's about odd,
non-standard syncing behaviour, so I think it fits sync_file_range well.
Like sync_file_range, it's trickier to use than it seems at first, so it
fits well with the other "keep this in mind before using it" requirements.

> So unless there is a shortage of syscall numbers or something, I find
> the request to omit this or tack it onto sync_file_range odd.  Could
> you explain the benefit?

Less code added, less bloat. Architecture independent, no need to update
all system call tables everywhere (all archs, libc versions and strace).
Two files changed, instead of 7 (which only hooks up x86). The code ends
up near the code it calls, so it makes contextual sense.

As for the reason not to add it at all, well, if everything that seemed
a good idea at the time was added as a system call it would be an even
bigger mess than it already is. So it doesn't have to be a bad idea to
not make it, not being useful enough is sufficient.

In this case it's just a performance improvement over sync(2). It doesn't
add a new feature. Main argument given for the performance problem seems
to be "NFS can be slow". Anything else?

Greetings,

Indan


