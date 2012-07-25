Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2GYTiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:38:09 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:26958 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751880Ab2GYTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:38:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ou9TbqIVM1k04N8F4Bk7YL8rTW36gAlAvrm0fqI8VlmnRoG
 khH5OPGeAu5MszHB.hEQQzkJEJZhfG2YP0xPGbdRQag2ickrKX26H8MRQslE
 JvHMMENlu0swbI72qgC.ztMta9SwYxqUVZIT4n6pcOqAdNOQUP7EbCsaL1BF
 je9CxB1NSbyNPJUs95Bf7Aj.6p.GRZTePmWfUXSyYxUqNKgzYCI8hkx6YJni
 HSwfDYv0EfGCayHiJlzREXj0j3wXv7TH_6tKt.QBwr6qMK6f6QqLCKLsR2AC
 8uhFNJyoP6HYFW2GM83swzaa63XMKbx5AkZPT4XOBulM2vQMG1ARdiF0KYx4
 Ya6EP5dDpR3YM6VfMqi.4KPpuH_O2oU0B4lA07XBjZVhJXQkpg2dWncPJqBf
 RdNvL4UCF07s.Xz4f
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 14:38:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <ak@linux.intel.com>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shu@intel.com>,
        Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 0/6] Avoid cache trashing on clearing huge/gigantic
 page
In-Reply-To: <20120725192850.GA4952@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.00.1207251434280.4995@router.home>
References: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com> <alpine.DEB.2.00.1207251346250.4995@router.home> <20120725192850.GA4952@tassilo.jf.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Andi Kleen wrote:

> > why exempt the 4K around the fault address? Is there a regression if that
> > is not exempted?
>
> You would get an immediate cache miss when the faulting instruction
> is reexecuted.

Nope. You would not get cache misses for all cachelines in the 4k range.
Only one.

> > I guess for anonymous huge pages one may assume that there will be at
> > least one write to one cache line in the 4k page. Is it useful to get all
> > the cachelines in the page in the cache.
>
> We did some measurements -- comparing 4K and 2MB with some tracing
> of fault patterns -- and a lot of apps don't use the full 2MB area.
> The apps with THP regressions usually used less than others.
> The patchkit significantly reduced some of the regressions.

Yup they wont use the full 2MB area. But are they using all the cache
lines of the 4k page that we are making hot?


