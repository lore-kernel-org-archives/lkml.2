Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1KUQ4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:56:33 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:45049 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1KUQ4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:56:31 -0500
Date: Mon, 21 Nov 2011 11:56:26 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Hugh Dickins <hughd@google.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
        Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Bug with "fix partial page writes"
Message-ID: <20111121165626.GD14568@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
 <alpine.LSU.2.00.1111201121120.1264@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1111201121120.1264@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
> We've seen no response to this, so Cc'ing Ted and linux-kernel,
> and I'll fill in some more detail below.

Hugh,

Thanks for reminding us about this.  Unfortunately bugzilla is still
down, so we'll have to track this via e-mail.

I mentioned this issue on the weekly ext4 call, and though there will
be a delay due to the Thanksgiving break, Allison said she would try
to take a look at this.  Hopefully other folks will as well.

> I did not reproduce either problem above with that.  Instead I found
> that backing out 02fac1297eb3 made fsx on 3.2-rc1 fail in a few minutes.
> But leaving 02fac1297eb3 in, fsx still failed in 20 minutes or an hour.
> On 3.1, fsx failed in a few minutes.  On 3.0, fsx failed in half an hour.
> On 2.6.39, fsx failed in a few minutes.  I had to go back to 2.6.38 for
> fsx to run successfully under memory pressure for more than two hours.
> 
> It looks as if ext4 testing has not been running fsx under memory
> pressure recently.  And although I didn't reproduce my main problems
> that way, it could well be that getting fsx to run reliably again
> under memory pressure will be the way to fix those problems.

Yes, I think we've been relying mostly on xfstests, and not
necessarily under extreme memory pressures.  Out of curiosity, what
sort of configuration were you using when you did the above tests?
(memory, swap, fs bock size, etc.)  Was it the same as you did with
your make -j20 kernel stress test?  And where you using any special
fsx options?

I agree that we should add better memory pressure testing to ext4.

Regards,

						- Ted
