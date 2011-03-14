Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1CNJ1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:27:36 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:43445 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1CNJ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:27:35 -0400
Message-ID: <0b7ab4190f781632fdb9a247f458edc2.squirrel@webmail.greenhost.nl>
In-Reply-To: <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <20110311235607.GB15853@elie>
    <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
    <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com>
    <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
    <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
Date: Mon, 14 Mar 2011 10:27:25 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: "Sage Weil" <sage@newdream.net>
Cc: "Greg KH" <greg@kroah.com>, "Jonathan Nieder" <jrnieder@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
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
X-Scan-Signature: 18b3e585b0ef946fc0f6ee9ab4fcc4ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, March 14, 2011 05:29, Sage Weil wrote:
> On Mon, 14 Mar 2011, Indan Zupancic wrote:
>> Everyone seems to want to add this new syncfs, but it's not even defined
>> what it does. "Same as sync, but only on one fs" is IMHO not good
>> enough, because sync's behaviour is pretty badly documented, and that's
>> a system call.
>
> How about the man page below?  I tried to avoid the somewhat antiquated
> implementation specific terminology in the sync(2) man page.

Good enough.

>
> I think adding this functionality into sync_file_range(2) is forcing
> unrelated functionality into an existing interface; sync_file_range
> operates on _files_, not an entire file system.  With each API addition
> it is more important to make the interface simple and intuitive than
> to minimize the size of our patches.  IMO that's why a new syscall
> is preferable to, say, an equivalent ioctl.

Your new syncfs also operates on files, it's only the name of sync_file_range
which is not very fitting. Other than that, syncing files in weird, nonstandard
ways is what it does and in that sense it's a good place for syncfs functionality.

But hey, it seems I'm the only one favouring that approach, and as you don't
mind the size of your patch, make sure to add support for syncfs to all other
23 archs too in your next patch submission.

Take care,

Indan


> Thanks-
> sage
>
>
> .TH SYNCFS 2 2011-03-13 "Linux" "Linux Programmer's Manual"
> .SH NAME
> syncfs \- commit cached file system state to stable storage
> .SH SYNOPSIS
> .B #include <unistd.h>
> .sp
> .B void syncfs(int fd);
> .SH DESCRIPTION
> .BR syncfs ()
> flushes any cached data modifications to the file system containing the
> file referenced by the file descriptor
> .I fd
> to stable storage (usually a disk).  This includes the results of any
> file modifications or other file system operations that have completed
> prior to the call to
> .BR syncfs(2).
> This is similar to
> .BR sync(2),
> but will commit changes for only a single file system instead of all
> mounted file systems.
> .SH ERRORS
> This function is always successful.
> .SH "SEE ALSO"
> .BR bdflush (2),
> .BR fdatasync (2),
> .BR fsync (2),
> .BR sync (2),
> .BR sync (8),
> .BR update (8)
>


