Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab2FARse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:48:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54659 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab2FARsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:48:33 -0400
Date: Fri, 1 Jun 2012 18:48:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git
Message-ID: <20120601174831.GK30000@ZenIV.linux.org.uk>
References: <20120601165614.GJ30000@ZenIV.linux.org.uk>
 <CA+55aFxcFKxY8f1-mQz68FX3Uax-i-FQ3Wj9=z+bUn0KxTCbHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxcFKxY8f1-mQz68FX3Uax-i-FQ3Wj9=z+bUn0KxTCbHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 10:38:53AM -0700, Linus Torvalds wrote:
> On Fri, Jun 1, 2012 at 9:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > There's a trivial conflict in Documentation/filesystems/vfs.txt - two
> > method prototypes added, one in mainline, one here. ?With the obvious
> > conflict resolution...
> 
> Actually, it's one removed in mainline, one added by your pull.
> 
> What I'd *really* like to see is a kind of summary of what this pull
> does, though. Please? That way I can make the merge messages be a
> whole lot more informative.

Umm...  It's a lot of misc stuff, unfortunately.  The obvious groups:
	* Miklos' atomic_open series; kills the damn abuse of ->d_revalidate()
by NFS, which was the major stumbling block for all work in that area.
	* ripping security_file_mmap() and dealing with deadlocks in the
area; sanitizing the neighborhood of vm_mmap()/vm_munmap() in general.
	* ->encode_fh() switched to saner API; insane fake dentry in
mm/cleancache.c gone.
	* assorted annotations in fs (endianness, __user)
	* parts of Artem's ->s_dirty work (jff2 and reiserfs parts)
	* ->update_time() work from Josef.
	* other bits and pieces all over the place.

Normally it would've been in two or three pull requests, but signal.git
stuff had eaten a lot of time during this cycle ;-/
