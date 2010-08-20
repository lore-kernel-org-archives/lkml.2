Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0HTMij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:38:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:52869 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0HTMif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:38:35 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Fri, 20 Aug 2010 14:38:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008192307.32526.agruen@suse.de> <1282276236.21419.2101.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282276236.21419.2101.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201438.16637.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 05:50:36 Eric Paris wrote:
> We must be doing something different...  What kernel?  what kconfig?
> What exact FS setup?  What exact steps are you taking?  What programs
> are you using to test east side?

I'm runnning 2.6.36-rc1, with CONFIG_FANOTIFY and 
CONFIG_FANOTIFY_ACCESS_PERMISSIONS on apparently.  I am watching the same 
directory with inotify and fanotify at the same time, that is, with both an 
inotify and an fanotify listener running in two separate processes.  The 
inotify listener is code I cannot send so easily, but I've shown the resulting 
strace.  The fanotify listener is the one from [1].

	[1] http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git

Together with the traces I've provided this should give you way enough clues 
to be able to look up in the code why listening for fanotify events apparently 
causes a concurrent inotify listener to return an inotify event with struct 
inotify_event->mask == 0 for each fanotify perm event.

Andreas
