Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2EVCIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2EVCIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:08:30 -0400
Date: Mon, 21 May 2012 22:08:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4+ dcache BUG.
Message-ID: <20120522020825.GA22961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120522011152.GA18115@redhat.com>
 <CA+55aFwimihFb=JTFMraAhYFSwR6bBt_Pmwfx0wLybUDq1JQ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwimihFb=JTFMraAhYFSwR6bBt_Pmwfx0wLybUDq1JQ0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06:51:51PM -0700, Linus Torvalds wrote:
 > On Mon, May 21, 2012 at 6:11 PM, Dave Jones <davej@redhat.com> wrote:
 > > Just hit this. Probably related to todays dcache changes ?
 > 
 > Almost certainly. Except:
 > 
 > > I'm not sure why, but the dcache.c line numbers don't match up..
 > > This kernel was v3.3-rc7-14528-g29db10d which looked like..
 > 
 > You seem to not have fetched any tags lately (so it says "3.3-rc7 +
 > 14528 commits" instead of something more relevant), and I can't make
 > sense of that SHA1 either (29db10d) either.
 > 
 > You probably have other changes in your tree as well, explaining the
 > SHA1 that I don't recognize?

ah, yeah. Mostly just stuff like removing noisy printk's that I get
tired of seeing when I run trinity.

 > What was the load that triggered this? Just a regular kernel compile?

kernel build doing make -j 64 on a 8 way machine. (quad core with ht)
(It has a really fast ssd, so it can really churn through builds quickly).

 > I see the "comm: cc1" there, and I'm a bit surprised, since I ran
 > those patches here locally a *lot*. Is this perhaps some low-memory
 > scenario?

hmm, that's a possibility. Machine has 4GB, but with all those gcc/ld's flying around,
maybe when it gets to a big link section..

	Dave

