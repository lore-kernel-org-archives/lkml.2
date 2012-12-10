Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2LJQs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:48:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab2LJQsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:48:55 -0500
Date: Mon, 10 Dec 2012 11:48:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Message-ID: <20121210164813.GA53431@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B936@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B936@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:43:03PM +0000, Seiji Aguchi wrote:
> > Can all these things really happen (did you run into this problem on a real system?). Or is this just a theoretical problem.  Ugly (but
> > practical) hacks might be OK to solve real problems. 
> 
> It is a theoretical problem right now.
> But it is a timing issue and there is a possibility to happen actually.
> 
> > But do we really want them to fix problems that actually never happen?
> 
> If we find a problem (even if it is theoretical), we can't say "It actually never happen.".
> 
> I have some reasons to submit this patch before reproducing actually.
> 
> 1)
> It is too late if we fix a problem after it actually happened in case where we apply Linux, including pstore, 
> to mission critical systems, because the failure of those systems has a great impact on a whole society.
> Customers in this area ask us to fix a problem as soon as possible.
> On the other hand, this kind of timing issue is hard to reproduce.
> So, our support service engineers often work all night to reproduce it.
> It is a nightmare for us.
> 
> If we can fix it with a small patch in adance, it is really helpful for us.

As I said in my email I just sent, it may not help you without testing it.
As there are probably other problems in that un-tested theoretical
scenario.

> 
> 2)
> In the long term, I plan to add a kmsg_dump to a kexec path because kdump may fail in the real world.
> In that case, we need another troubleshooting material like pstore to detect a root cause of failure.

But you are assuming that kmsg_dump is perfect and it isn't, in which case
by putting kmsg_dump in the kdump path, you actually may be blocking kdump
from working.

That is the biggest hold up for those guys from including it I believe.

Cheers,
Don
