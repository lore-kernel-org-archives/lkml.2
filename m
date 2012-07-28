Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2G1Cj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 22:39:58 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41746 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab2G1Cj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 22:39:56 -0400
Date: Fri, 27 Jul 2012 22:39:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, w@1wt.edu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@vger.kernel.org, DJ Johnston <dj.johnston@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] random: mix in architectural randomness in extract_buf()
Message-ID: <20120728023938.GA3766@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, w@1wt.edu, ewust@umich.edu,
	zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net, stable@vger.kernel.org,
	DJ Johnston <dj.johnston@intel.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>
References: <20120725151000.GA30996@thunk.org>
 <1343237822-7789-1-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343237822-7789-1-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I'll add this patch to the random tree.  I've modified the commit
message a bit since the speed advertisement of RDRAND is rather
pointless --- processes aren't generating session keys or long term
keys at a high rate, and programs can't count on /dev/random being
super fast and having unlimited entropy, since for most platforms and
even most x86 CPU's deployed in service today, this isn't true --- and
making your userspace program depond upon /dev/random in such a way
that it only works on Ivy Bridge CPU's might be good for Intel from a
vendor lock-in perspective, but it's really bad, non-portable
programming style.

Also, in the future arch_get_random_long() will almost certainly be
hooked up for other architectures, so putting an extended
advertisement for RDRAND really isn't appropriate.

					- Ted

commit d2e7c96af1e54b507ae2a6a7dd2baf588417a7e5
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Jul 27 22:26:08 2012 -0400

    random: mix in architectural randomness in extract_buf()
    
    Mix in any architectural randomness in extract_buf() instead of
    xfer_secondary_buf().  This allows us to mix in more architectural
    randomness, and it also makes xfer_secondary_buf() faster, moving a
    tiny bit of additional CPU overhead to process which is extracting the
    randomness.
    
    [ Commit description modified by tytso to remove an extended
      advertisement for the RDRAND instruction. ]
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Acked-by: Ingo Molnar <mingo@kernel.org>
    Cc: DJ Johnston <dj.johnston@intel.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: stable@vger.kernel.org
