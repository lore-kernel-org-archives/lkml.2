Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2BZUUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 15:20:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2BZUUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 15:20:49 -0500
Date: Sun, 26 Feb 2012 15:20:10 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        n-horiguchi@ah.jp.nec.com, kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org
Subject: Re: Regression: Bad page map in process xyz
Message-ID: <20120226202010.GA7353@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Jiri Slaby <jslaby@suse.cz>, n-horiguchi@ah.jp.nec.com,
	kamezawa.hiroyu@jp.fujitsu.com,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org
References: <4F421A29.6060303@suse.cz>
 <201202261027.48029.maciej.rutecki@gmail.com>
 <alpine.LSU.2.00.1202260502450.5648@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.00.1202260502450.5648@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 05:10:31AM -0800, Hugh Dickins wrote:
 > On Sun, 26 Feb 2012, Maciej Rutecki wrote:
 > > On poniedziałek, 20 lutego 2012 o 11:02:17 Jiri Slaby wrote:
 > > > Hi,
 > > > 
 > > > I'm getting a ton of
 > > > BUG: Bad page map in process zypper  pte:676b700029736c6f pmd:44967067
 > > > when trying to upgrade the system by:
 > > > zypper dup
 > > > 
 > > > I bisected that to:
 > > > commit afb1c03746aa940374b73a7d5750ee05a2376077
 > > > Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
 > > > Date:   Fri Feb 17 10:57:58 2012 +1100
 > > > 
 > > >     thp: optimize away unnecessary page table locking
 > > > 
 > > > thanks,
 > > 
 > > I created a Bugzilla entry at 
 > > https://bugzilla.kernel.org/show_bug.cgi?id=42820
 > > for your bug/regression report, please add your address to the CC list in 
 > > there, thanks!
 > 
 > No, thanks for spotting it, but please remove from the regressions
 > report: it's not a regression in 3.3-rc but in linux-next - don't take
 > my word for it, check the commit and you'll not find it in 3.3-rc.
 > 
 > We do still need to get the fix into linux-next: Horiguchi-san, has
 > akpm put your fix in mm-commits yet?  Please send it again if not.

FWIW, we've been getting a bunch of these since 3.0 in Fedora.
I've been trying to come up with some way of trying to reproduce them
myself, without any luck. Some of our users seem to hit them surprisingly easily.

At first I started wondering if it was just bad hardware, but the frequency
that we've been getting reports seems to suggest something more screwed up.

https://bugzilla.redhat.com/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=MODIFIED&bug_status=ON_DEV&bug_status=ON_QA&bug_status=VERIFIED&bug_status=RELEASE_PENDING&bug_status=POST&classification=Fedora&component=kernel&product=Fedora&query_format=advanced&short_desc=bug+page+map&short_desc_type=allwordssubstr&version=15&version=16&version=rawhide&order=bug_id&query_based_on=

Until last week, we only had reports up until 3.2, but now that the F17 alpha
is getting tested, people are starting to hit it on 3.3rc too

I'll try a test build with that commit backed out for our users to try out
next week.

	Dave

