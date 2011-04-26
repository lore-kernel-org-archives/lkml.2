Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab1DZWdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:33:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753770Ab1DZWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:33:04 -0400
Date: Tue, 26 Apr 2011 17:32:57 -0500
From: Russ Anderson <rja@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        rja@americas.sgi.com
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Message-ID: <20110426223257.GB27953@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1303135222-17118-2-git-send-email-bp@amd64.org> <20110419171340.GE6640@elte.hu> <20110419173521.GA25374@aftab> <20110419174446.GA13616@elte.hu> <20110420102349.GB1361@aftab> <m1hb9mnmqs.fsf@fess.ebiederm.org> <20110426074238.GA22448@aftab> <m1y62wk9i8.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y62wk9i8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:06:39PM -0700, Eric W. Biederman wrote:
> Borislav Petkov <bp@amd64.org> writes:
> > On Mon, Apr 25, 2011 at 03:40:11PM -0400, Eric W. Biederman wrote:
> >> > From: Borislav Petkov <borislav.petkov@amd.com>
> >> > Date: Wed, 13 Apr 2011 14:32:06 +0200
> >> > Subject: [PATCH -v2.1 2/2] x86, MCE: Drop the default decoding notifier
> >> >
> >> > The default notifier doesn't make a lot of sense to call in the
> >> > correctable errors case. Drop it and emit the mcelog decoding hint only
> >> > in the uncorrectable errors case and when no notifier is registered.
> >> > Also, limit issuing the "mcelog --ascii" message in the rare case when
> >> > we dump unreported CEs before panicking.
> >> >
> >> > While at it, remove unused old x86_mce_decode_callback from the
> >> > header.
> >> 
> >> Can we please print something if we please log something in the
> >> case of a correctable error, when we only report it via mcelog?
> >> 
> >> I have a stupid recent intel cpu here that hits that case and without
> >> the default x86_mce_decode_callback I wouldn't have even known that I am
> >> getting something like 50 correctable errors an hour on one of my
> >> machines.  In particular I am it hits so often I am seeing:
> >> "mce_notify_irq: 2 callbacks suppressed".  I need to get those dimms
> >> replaced soon because in a new product I simply can't imagine that many
> >> correctable errors.
> >
> > Isn't there a mcelog daemon or something that polls /dev/mcelog and
> > tells you about those DRAM ECCs in some log file where you're supposed
> > to look? :)
> 
> On fedora 14 there is a cron job that writes to /var/log/mcelog, and
> does not go through syslog.

Interesting.  I'm running fedora 14 and don't have a /var/log/mcelog
file or see an mcelog package (not that I'd looked until just now).

>                              But you have to be proactive and look
> there.  If the people who work on this code can't even remember
> where to look I can't imagine how anyone else can remember.
> Which is why I object to the removal of the one printk that told
> me something was broken on my machine.

Historically hardware error reporting has been very platform
dependent.  Those differences made it difficult to come up with
agreement on standard ways to report errors.  You raise a good
point that it needs to work better.

> So far from what I have seen /dev/mcelog and the userspace mcelog is
> over complicated and near useless.

/dev/mcelog is extremely useful to SGI.  As you said, "you have to 
be proactive and look there" which we are and do.  :-)

>                                     It seems to focused around the
> notion that "This is not a software problem, please do not bug
> Andi Kleen about it"
> 
> Well it is a hardware problem so I do need to RMA that hardware.
> Sigh.

You raise a good issue that users do need to know when their 
hardware is having issues.

> Eric

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
