Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2BZXIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:08:49 -0500
Received: from mail.lang.hm ([64.81.33.126]:34678 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab2BZXIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:08:48 -0500
Date: Sun, 26 Feb 2012 15:08:34 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Henrik Rydberg <rydberg@euromail.se>
cc: Bobby Powers <bobbypowers@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
In-Reply-To: <20120226104701.GA18152@polaris.bitmath.org>
Message-ID: <alpine.DEB.2.02.1202261503320.4108@asgard.lang.hm>
References: <20120224191535.GA4505@polaris.bitmath.org> <20120224192643.GB24120@kroah.com> <20120224201027.GA4859@polaris.bitmath.org> <20120224201655.GA5994@kroah.com> <20120224203715.GA4995@polaris.bitmath.org> <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org> <20120224213027.GB15735@thunk.org> <20120224221459.GA5254@polaris.bitmath.org> <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com> <20120226104701.GA18152@polaris.bitmath.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Feb 2012, Henrik Rydberg wrote:

>>> The main issue that set me off has been sufficiently diluted in the
>>> (selective) discussion so as to no longer make sense as a reply: At
>>> some point, in-tree or out-of-tree will no longer be distinguishable,
>>
>> Please explain how you would be unable to distinguish between a driver
>> that lives in the kernel source tree, and one that does not.
>
> The SUD pointed to in the beginning of the thread is an example of
> this, but I was not thinking of it in quite so literal terms. Rather,
> I was imagining that as the kernel grows and the in-kernel interfaces
> matures, the amount of actual communication between different portions
> of the code diminishes. Code on opposite sides of a stable interface
> is, for all practical purposes, separated. Whether that code lives
> in-tree or out-of tree is then of little consequence.

the point that you seem to be missing is that the interfaces between the 
different areas of the kernel are not stable, they change over time. When 
both sides of the interface are in the kernel, this is not a problem, both 
sides get changed, but if one side was out of the kernel, then you either 
can't make the change, or have a flag day change where both sides need to 
change in lock-step (and downgrading is hard as both sides need to change 
again)

This is completely ignoring the performance and security aspects of 
userspace components vs kernel components.

Ted is explaining the performance aspects well, but let's look at the 
security aspects as well.

It's not just a case of "if something in userspace crashes, it doesn't 
crash the kerenl", it's also a case that "if you have a userspace 
component, then the kernel must sanity check the userspace interface to 
defend against rogue userspace". Doing these checks is not cheap (adding 
to performance overhead), and may not even be possible (how do you know 
if the command being sent to the SCSI bus is safe or not?)

David Lang
