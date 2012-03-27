Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2C0FCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 01:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2C0FCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 01:02:50 -0400
Date: Tue, 27 Mar 2012 01:02:38 -0400
From: Dave Jones <davej@redhat.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Garrett-Glaser <jason@x264.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
Message-ID: <20120327050238.GA19496@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Brian Gerst <brgerst@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jason Garrett-Glaser <jason@x264.com>,
	Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
 <CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
 <CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
 <CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 12:42:19AM -0400, Brian Gerst wrote:

 > > I did only very limited profiling of the 32-bit case, but it's really
 > > just four cheap ALU instructions there and didn't really show up at
 > > all in the limited profiles I did. And at least I checked that the
 > > code worked. I have to say that the advantage of "vectorizing" this
 > > code is obviously much less if you can only do 4-byte "vectors", so I
 > > didn't actually time whether the patch *improves* anything on x86-32.
 > >
 > 
 > This patch is causing my system (x86-64, Fedora 16) to fail to boot
 > when DEBUG_PAGEALLOC=n.  No oops, but these error messages were in the
 > log for the bad kernel:

I saw this too, it was fixed by f132c5be05e407a99cf582347a2ae0120acd3ad7 for me.
Does your kernel have that commit ?

	Dave


