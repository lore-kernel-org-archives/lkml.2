Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1CAVi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:38:28 -0500
Received: from www.tglx.de ([62.245.132.106]:43721 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab1CAVi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:38:28 -0500
Date: Tue, 1 Mar 2011 22:38:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v6 1/1] PRUSS UIO driver support
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF36683@dbde02.ent.ti.com>
Message-ID: <alpine.LFD.2.00.1103012232220.2701@localhost6.localdomain6>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com> <1298926895-5294-2-git-send-email-pratheesh@ti.com> <20110228212638.GB16806@local> <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com> <20110301183334.GC20497@local>
 <B85A65D85D7EB246BE421B3FB0FBB593024BF36683@dbde02.ent.ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, TK, Pratheesh Gangadhar wrote:

> Hi,
> > -----Original Message-----
> > From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> > Sent: Wednesday, March 02, 2011 12:04 AM
> > To: TK, Pratheesh Gangadhar
> > Cc: Hans J. Koch; linux-kernel@vger.kernel.org; gregkh@suse.de;
> > tglx@linutronix.de; sshtylyov@mvista.com; arnd@arndb.de; Chatterjee, Amit;
> > davinci-linux-open-source@linux.davincidsp.com; linux-arm-
> > kernel@lists.infradead.org
> > Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support

Sigh, can you please use a mailer which does not repeat the headers
for no value and just has a single line like this:

> > On Tue, Mar 01, 2011 at 10:15:27AM +0530, TK, Pratheesh Gangadhar wrote:
> > Anyway, please don't use that kind of argumentation. The next newbie
> > developer might copy your work as a basis for his new driver, and there
> > it probably won't work.
> > 
> > Simply put the spin_lock_init before the loop.
> > 
> Agree, will fix this in next version.

As I said before, we want stuff initialized when it is possibly
used. But first of all we ant people to use the proper mechanisms to
achive that.

If that's a module global lock then it needs to be instantiated by

static DEFINE_SPINLOCK(lock);

which implies the initialization of the lock.

If it's a lock which is in allocated memory then the

   spin_lock_init(&lock);

wants to be before it can be possibly used.

So in your case DEFINE_SPINLOCK is the correct solution.

Thanks,

	tglx
