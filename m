Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0IIU1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:27:06 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:43866 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab0IIU1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:27:05 -0400
X-Greylist: delayed 2041 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 16:27:04 EDT
Date: Thu, 9 Sep 2010 21:53:01 +0200
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Greg KH <greg@kroah.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [stable] [tip:x86/urgent] x86: Add memory modify constraints
	to xchg() and cmpxchg()
Message-ID: <20100909195301.GA18291@nomi.cz>
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <4C5759FF.1000807@goop.org> <20100802235950.GA662@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100802235950.GA662@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2.6.32.21 does not boot on my HP Compaq nx7300. I bisected it to this patch:

On Mon, Aug 02, 2010 at 04:59:50PM -0700, Greg KH wrote:
> On Mon, Aug 02, 2010 at 04:51:27PM -0700, Jeremy Fitzhardinge wrote:
> >  On 07/27/2010 10:33 PM, tip-bot for H. Peter Anvin wrote:
> > >Commit-ID:  113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> > >Gitweb:     http://git.kernel.org/tip/113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> > >Author:     H. Peter Anvin<hpa@zytor.com>
> > >AuthorDate: Tue, 27 Jul 2010 17:01:49 -0700
> > >Committer:  H. Peter Anvin<hpa@zytor.com>
> > >CommitDate: Tue, 27 Jul 2010 17:14:02 -0700
> > >
> > >x86: Add memory modify constraints to xchg() and cmpxchg()
> > 
> > Here's the 2.6.32 version for stable.
> 
> Thanks, I'll queue it up when it hits Linus's tree.

Here's a video of the crash: http://store.lisk.in/tmp/09092010019.mp4
With boot_delay=30, it sometimes just reboots and sometimes prints the trace.
Without it, it always prints the trace. The crash occurs during the
initialization of intel-agp (which explains why I can't reproduce it in qemu).
More details in the video.

The system boots and works just fine with 2.6.32.21 with the patch reverted.
v2.6.36-rc3-185-gd56557a works fine as well, perhaps there were other fixes
that didn't get to stable (e.g. 4532b30).

I'm compiling the kernel with the latest gcc in Debian (-dumpversion says
4.4.5, dpkg reports 4:4.4.4-2). Shall I post dmesg/lspci as well?

Since I have an easy workaround and other things to do, I won't spend time
trying to backport those other fixes myself, but if you're going to fix this,
I will help with testing.

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
