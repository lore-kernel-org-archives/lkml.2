Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LCTfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:35:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59090 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751033Ab2LCTfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:35:06 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18eIzZZ58Ee/yWd2eGGn4oZsbayiCkzLmRhgc/rNg
	sRaIq+x7DWQF69
Date: Mon, 3 Dec 2012 21:35:00 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@soupermouf
To: Eric Paris <eparis@parisplace.org>, "Theodore Ts'o" <tytso@mit.edu>
cc: Roland Eggner <edvx1@systemanalysen.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
In-Reply-To: <CACLa4psEfdA17mcjVHhUfgmARXTZ6AVA7QJ77DymXBeVtgjZ5w@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1212032125520.4173@soupermouf>
References: <1353855815.22969.20.camel@soupermouf> <1354452243.22969.48.camel@soupermouf> <20121202225051.GA13685@mobil.systemanalysen.net> <alpine.LFD.2.02.1212030120090.1646@soupermouf> <20121203174342.GB20260@thunk.org>
 <CACLa4psEfdA17mcjVHhUfgmARXTZ6AVA7QJ77DymXBeVtgjZ5w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012, Eric Paris wrote:

> On Mon, Dec 3, 2012 at 12:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
>> If you are seeing a large number of inodes still in the ext4 inode
>> cache after using drop_caches, then I'd look to see whether you have
>> something like SELinux or auditing enabled which is pinning a bunch of
>> dentries or inodes
>
> You can safely ignore this suggestion as it does make sense.  SELinux
> only grabs a references to dentries during its call to
> fs_ops->getxattr, which can't last a meaningful length of time (unless
> the filesystem is busted).  It only grabs references to inodes during
> system initialization, when you couldn't have many in core.
>
> Audit, likewise, only grabs a reference to a dentry during execve()
> and only long enough to run getxattr and does not grab any reference
> directly to an inode at all.
>

AFAICT I use neither SELinux nor audit.

>> or whether your backup program (or some other
>> program running on your system) is keeping lots of directories or
>> inodes open for some reason.
>
> Certainly could be this suggestion though..
>

I've managed to reproduce the scenario with concurrent "du" commands 
running on the filesystems. I'll try doing it once more, but it may take a 
while to get the dmesg/slabinfo etc output, since even a realtime root 
shell is non-responsive for many minutes.

What other debug output do you suggest to get, to find out why ext4 
inodes are pinned?


Thanks,
Dimitris

