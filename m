Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2B0AyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:54:13 -0500
Received: from mail.lang.hm ([64.81.33.126]:54843 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2B0AyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:54:12 -0500
Date: Sun, 26 Feb 2012 16:53:58 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Henrik Rydberg <rydberg@euromail.se>
cc: Bobby Powers <bobbypowers@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
In-Reply-To: <20120227000129.GA2265@polaris.bitmath.org>
Message-ID: <alpine.DEB.2.02.1202261646480.4108@asgard.lang.hm>
References: <20120224201027.GA4859@polaris.bitmath.org> <20120224201655.GA5994@kroah.com> <20120224203715.GA4995@polaris.bitmath.org> <20120224205651.GA13333@kroah.com> <20120224212238.GA5178@polaris.bitmath.org> <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org> <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com> <20120226104701.GA18152@polaris.bitmath.org> <alpine.DEB.2.02.1202261503320.4108@asgard.lang.hm> <20120227000129.GA2265@polaris.bitmath.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, Henrik Rydberg wrote:

> Hi David,
>
>> the point that you seem to be missing is that the interfaces between
>> the different areas of the kernel are not stable, they change over
>> time.
>
> The argument was based on the idea that they would stabilize over
> time. However, I realize this may not be true, which was also touched
> upon in a later reply. The heavy-tailed nature of large changes in
> open-source projects seems to put some hard numbers behind that claim [1].

What you are hearing from the long-time kernel developers is that they 
expect the interfaces to change over time.

Remember, the linux kernel has been around for a long time, and as a 
result, the interfaces have gone through many iterations. There is no 
reason to believe that the current version is the final one, and the 
kernel developers now expect that the current interfaces are _not_ going 
to remain the same forever, they expect that new technology will drive 
changes in these interfaces. This is especially true for the types of 
things that device drivers need.

Take for example locking. That is an implicit part of the interface to the 
device drivers, and is are area with a fairly high rate of change today. 
Anyone who claims that the current locking is 'correct' and can be 
depended on by an out-of-tree driver for even a couple of kernel releases 
is going to be either laughed at or ignored as being too ignorant to 
matter.

Yes, you can look around and find interfaces in the kernel that have not 
changed for a long time, but I'll bet that for every example you find, 
someone else could find an example of an interface that had remained 
unchanged for just about as long, but has changed fairly recently.

David Lang
