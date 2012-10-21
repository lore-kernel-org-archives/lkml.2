Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab2JUWSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 18:18:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56717 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab2JUWSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 18:18:10 -0400
Date: Sun, 21 Oct 2012 18:16:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Airlie <airlied@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121021221640.GA2027@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	Borislav Petkov <bp@alien8.de>, Dave Airlie <airlied@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Pekka Enberg <penberg@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
 <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021111832.GB6504@liondog.tnic>
 <CAFLxGvzz4eS5Rd3b4mX4wef-2mnh-aNVrjty6F6vSmwkgdqWaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzz4eS5Rd3b4mX4wef-2mnh-aNVrjty6F6vSmwkgdqWaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 01:29:35PM +0200, richard -rw- weinberger wrote:
> Every kernel developer has his own wrapper script to make qemu usable.
> IMHO it's time to add such a script to the kernel tree.

One observation I'll make is that for many people, what you want to do
is a *lot* more than just simply create a wrapper script to fire up
qemu.  For me to do my testing, I want to build a kernel on the host
OS, and then fire up a script which fires up xfstests and runs it with
a collection of different file system mount options to do my ext4
testing.   I've shared that here:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

where the host-side scripts are in the kvm-xfstests directory, and the
guest-side scripts are in the kvm-autorun directory.  I can pass in a
set of fs configurations and xfstest test numbers via the command line
on the host os, i.e., "kvm-xfstests -c 4k,ext4,nojournal
13,225,245,246".  And then afterwards the scripts parse out the test
output and summarizes so it's easy to see what passed and what failed.

So the bottom line is that for me at least, starting up qemu is a very
tiny part of what I need to do in order to do my testing.  If you want
to really encourage good testing, what would be better is to encourage
more people to create standardized testing and benchmarking scripts
that many kernel developers can easily run.  And those are going to be
complex enough that I don't think it makes sense for them to live in
the kernel tree.

    	     	    	       	  	   - Ted

