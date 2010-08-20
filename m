Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0HTLIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:08:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0HTLH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:07:59 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Fri, 20 Aug 2010 13:07:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008200141.10068.agruen@suse.de> <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201307.37748.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 05:38:17 Eric Paris wrote:
> On Fri, 2010-08-20 at 01:41 +0200, Andreas Gruenbacher wrote:
> > 	(2) Construct a file descriptor that refers to the file that could not be
> > 	    dentry_open()ed, but which cannot be used for any I/O, and pass the
> > 	    error condition in a separate field.  The kernel has all the
> > 	    information needed for doing that, and it shouldn't be hard to
> > 	    implement.
> > 	    
> > 	    That way, the listener always has a file descriptor to poke around
> > 	    with.
> > 
> > Failing to do (2) right now, I think it still makes sense to separate the
> > file descriptor from the error code in struct fanotify_event_metadata;
> > this would enable us to do (2) later if we decide to.
> 
> In reference to (2), I don't even understand what an fd is that can't be
> used for anything.  I'll let Al or Christoph respond if they feel like
> it, but it sounds crazy to me.  You want to just magic up some struct
> file and attach a struct path to it even though dentry_open() failed?
> So you can do what with it?

I've never said the fd can't be used for anything.  The idea would be to
allow the file to be stat()ed, to poke around in /proc/fd/ in the hope to
get a somewhat useful pathname out, or to use something like xstat() on the
fd one day (David Howells is going to be looking into that).

It would be a good thing to be able to use the same mechanisms for
identifying the file that are available for a "normal" file descriptor.

> On a more realistic note, I'm not opposed to (1), however, your
> arguments would lead one to reject inotify as the IN_OVERFLOW or oom
> conditions will result in silently lost events or events which provide
> no useful information since the notification system has broken down.

Nonsense.  An overflow event obviously is not associated with any one file,
so that would be the (only) case where you should get an event that doesn't
refer to a file.

Andreas
