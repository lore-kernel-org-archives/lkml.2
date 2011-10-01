Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1JAOjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:39:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47971 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab1JAOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:39:03 -0400
Date: Sat, 1 Oct 2011 10:39:00 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [BUG] copy file result with zero
Message-ID: <20111001143900.GH28234@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Young <hidave.darkstar@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
> Hi,
> 
> Weird problem, when I build app from source,
> make; make install
> run the command, but got "cannot execute binary file"
> 
> hexdump shows the installed binary is full of zero
> 
> Is it related to ext4 fiemap problem described below?
> http://lwn.net/Articles/429349/

There is general agreement that /bin/cp should not have been relying
on FIEMAP, and I believe the more recent versions of /bin/cp have
removed that code by default pending implementation of
SEEK_HOLE/SEEK_DATA.  That being said, ext4 had a workaround to its
FIEMAP implementation that landed in 2.6.39, and you're using
3.1.0-rc6.

> I finally managed to find the way to reproduce this:
> just cp a elf binary A  to file B, then cp B to file C,  then you will get:
> A == B != C
> 
> ie.
> cp /bin/ls ls1
> cp ls1 ls2
> 
> ls2 will be filled with zero

If you add a "sync" between the two copies, does that work around the
problem?  I bet it will...

My suggestion is to upgrade to a newer version of coreutils that
doesn't try to use FIEMAP.

					- Ted
