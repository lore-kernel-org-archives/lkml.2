Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2B0ABV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:01:21 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:33848 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2B0ABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:01:20 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhZ5AB7HSk9V5qjTPGdsb2JhbABCshkDgQYZAQEBATc0gXMBAQQBDiwcDxQFCwgDRhQlCoguCQe2ehOKV4IkBQETAgIgAgoBBgsCBgcMFAkChEMIATwKCRIKHTaCO2MElTyFbY0D
X-IronPort-AV: E=Sophos;i="4.73,488,1325458800"; 
   d="scan'208";a="50710402"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 27 Feb 2012 01:01:29 +0100
To: david@lang.hm
Cc: Bobby Powers <bobbypowers@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120227000129.GA2265@polaris.bitmath.org>
References: <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org>
 <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
 <20120226104701.GA18152@polaris.bitmath.org>
 <alpine.DEB.2.02.1202261503320.4108@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1202261503320.4108@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> the point that you seem to be missing is that the interfaces between
> the different areas of the kernel are not stable, they change over
> time.

The argument was based on the idea that they would stabilize over
time. However, I realize this may not be true, which was also touched
upon in a later reply. The heavy-tailed nature of large changes in
open-source projects seems to put some hard numbers behind that claim [1].

> When both sides of the interface are in the kernel, this is
> not a problem, both sides get changed, but if one side was out of
> the kernel, then you either can't make the change, or have a flag
> day change where both sides need to change in lock-step (and
> downgrading is hard as both sides need to change again)

Assuming the interfaces changes, this follows naturally, of course.

> This is completely ignoring the performance and security aspects of
> userspace components vs kernel components.

Indeed.

> Ted is explaining the performance aspects well, but let's look at
> the security aspects as well.
> 
> It's not just a case of "if something in userspace crashes, it
> doesn't crash the kerenl", it's also a case that "if you have a
> userspace component, then the kernel must sanity check the userspace
> interface to defend against rogue userspace". Doing these checks is
> not cheap (adding to performance overhead), and may not even be
> possible (how do you know if the command being sent to the SCSI bus
> is safe or not?)

No doubt, an open-ended system has its own set of problems. At any
given system size, the question is how this balances against a closed
system. The assumption I made was that as the system grows, the
balance would shift in favor of an open-ended system. This may not be
the case at all, as you are saying. It would be nice to be able to see
this in a quantitative manner if possible.

Thanks for taking the time to respond.

Henrik

[1] http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.91.7114
