Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2LCSrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:47:18 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61679 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2LCSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:47:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121203174342.GB20260@thunk.org>
References: <1353855815.22969.20.camel@soupermouf>
	<1354452243.22969.48.camel@soupermouf>
	<20121202225051.GA13685@mobil.systemanalysen.net>
	<alpine.LFD.2.02.1212030120090.1646@soupermouf>
	<20121203174342.GB20260@thunk.org>
Date: Mon, 3 Dec 2012 13:47:15 -0500
Message-ID: <CACLa4psEfdA17mcjVHhUfgmARXTZ6AVA7QJ77DymXBeVtgjZ5w@mail.gmail.com>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
From: Eric Paris <eparis@parisplace.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Dimitrios Apostolou <jimis@gmx.net>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 12:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> If you are seeing a large number of inodes still in the ext4 inode
> cache after using drop_caches, then I'd look to see whether you have
> something like SELinux or auditing enabled which is pinning a bunch of
> dentries or inodes

You can safely ignore this suggestion as it does make sense.  SELinux
only grabs a references to dentries during its call to
fs_ops->getxattr, which can't last a meaningful length of time (unless
the filesystem is busted).  It only grabs references to inodes during
system initialization, when you couldn't have many in core.

Audit, likewise, only grabs a reference to a dentry during execve()
and only long enough to run getxattr and does not grab any reference
directly to an inode at all.

> or whether your backup program (or some other
> program running on your system) is keeping lots of directories or
> inodes open for some reason.

Certainly could be this suggestion though..
