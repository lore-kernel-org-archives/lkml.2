Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0HYCEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:04:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0HYCE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:04:29 -0400
Date: Wed, 25 Aug 2010 12:04:13 +1000
From: Neil Brown <neilb@suse.de>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel@CEA.FR" <philippe.deniel@cea.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100825120413.7d5c5994@notabene>
In-Reply-To: <AANLkTi=vYJDT_6YrfugE1N-k0Sj+abQBw7vQeG1GPhUP@mail.gmail.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100820083057.GA10039@infradead.org>
	<20100820195303.20b17210@notabene>
	<20100820115135.GQ31363@ZenIV.linux.org.uk>
	<20100821100900.4b15fe08@notabene>
	<17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com>
	<20100823090604.6c735c80@notabene>
	<AANLkTi=vYJDT_6YrfugE1N-k0Sj+abQBw7vQeG1GPhUP@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 11:41:10 +0200
Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:

> On Mon, Aug 23, 2010 at 1:06 AM, Neil Brown <neilb@suse.de> wrote:
> > On Sat, 21 Aug 2010 01:13:52 -0600
> > Andreas Dilger <andreas.dilger@oracle.com> wrote:
> >
> >> On 2010-08-20, at 18:09, Neil Brown <neilb@suse.de> wrote:
> >> > How about a new AT flag:  AT_FILE_HANDLE
> >> >
> >> > Meaning is that the 'dirfd' is used only to identify a filesystem (vfsmnt) and
> >> > the 'name' pointer actually points to a filehandle fragment interpreted in
> >> > that filesystem.
> 
> Why ot creating a special file system for this kind of operation ?
> I mean a vfsmnt filesystem, with each directory on the root is a
> symlink to the root of the real vfsmnt root ?
> 
> I could be even be in proc space like /proc/self/vfsmnt
> 
> path_to_handle will return a relative path from this directory like
> 0x75843558/somehandle (if X is on /usr/bin/X and usr is mounted by
> filesystem 0x75843558)
> path_to_fshandle() will return 0x75843558
> 
> opening file handle will be just a matter to thus open
> /proc/self/vfsmount/0x75843558/somehandle
> 
> Permission will be determined by vfsmount filesystem.
> 
> No need to create new syscall all te handle to filename will be handle
> by the vfsmount filesystem
> 
> We could even use at existing command. The dirfd will need to be only
> /proc/self/vfsmnt (and if you need to get a fd without mounting /proc
> create a syscall to get this fd).
> 
> Does sound plausible ?
>

I don't think so.

I'm not 100% certain what you are proposing, but I think the basic idea is a
virtual filesystem where giving a textual filehandle as a name gives access
to the file with that filehandle.

This could only work by creating a virtual symlink from the name to the
object in whichever filesystem - somewhat like /proc/self/fd/*.
This could be used to open the file, not to create a hard-link or read a
symlink which are two of the issues we are struggling with.

Maybe I have misunderstood you though.

NeilBrown
