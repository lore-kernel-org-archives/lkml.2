Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1BQFrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:47:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35126 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1BQFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:47:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Feb 2011 14:41:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] memcg: break out event counters from other stats
Message-Id: <20110217144116.58d71a7d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110217143315.858dd090.kamezawa.hiroyu@jp.fujitsu.com>
References: <1297920842-17299-1-git-send-email-gthelen@google.com>
	<1297920842-17299-2-git-send-email-gthelen@google.com>
	<20110217143315.858dd090.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 14:33:15 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 16 Feb 2011 21:34:01 -0800
> Greg Thelen <gthelen@google.com> wrote:
> 
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > For increasing and decreasing per-cpu cgroup usage counters it makes
> > sense to use signed types, as single per-cpu values might go negative
> > during updates.  But this is not the case for only-ever-increasing
> > event counters.
> > 
> > All the counters have been signed 64-bit so far, which was enough to
> > count events even with the sign bit wasted.
> > 
> > The next patch narrows the usage counters type (on 32-bit CPUs, that
> > is), though, so break out the event counters and make them unsigned
> > words as they should have been from the start.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Hmm..but not mentioning the change "s64 -> unsigned long(may 32bit)" clearly
isn't good behavior. 

Could you clarify both of changes in patch description as
==
This patch
  - devides counters to signed and unsigned ones(increase only).
  - makes unsigned one to be 'unsigned long' rather than 'u64'
and
  - then next patch will make 'signed' part to be 'long'
==
for changelog ?

Thanks,
-Kame


