Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab0HDCbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:31:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57182 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0HDCbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:31:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 11:26:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH -mm] hibernation: freeze swap at hibernation (Was
 Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100804112629.780e512a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
	<201008040109.15818.rjw@sisk.pl>
	<20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 08:31:19 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 4 Aug 2010 01:09:15 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday, August 02, 2010, KAMEZAWA Hiroyuki wrote:
> > > On Fri, 30 Jul 2010 13:14:32 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 
> > > > On Thu, 29 Jul 2010 21:10:10 -0700
> > > > Hugh Dickins <hughd@google.com> wrote:
> > > > 
> > > > > On Thu, Jul 29, 2010 at 5:01 PM, KAMEZAWA Hiroyuki
> > > > > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > > 
> > > > > > I think the best way is kexec(). But maybe rollback from hibernation failure
> > > > > > will be difficult. Considering how crash-dump works well and under maintainance
> > > > > > by many enterprise guys, hibernation-by-kexec is a choice. I think. It can make
> > > > > > reuse of kdump code, ...or, hibernation-resume code can eat kdump image
> > > > > > directly. Maybe the problem will be the speed of dump.
> > > > > 
> > > > > I've no appetite for a total rework of hibernation, and I don't see
> > > > > how that would
> > > > > address the issue: I'm just looking for some protection against swap
> > > > > reuse danger.
> > > > > 
> > > > Okay ;) (And I forget that kexec has to prepare memory at boot time for 2nd kernel.
> > > > It will be harmful for small device guys.)
> > > > 
> > > > I'll prepare a routine not-quick-fix.
> > > 
> > > Ok, here. Passed easy tests as
> > > # echo disk > /sys/power/state
> > > 

Sorry, I found this patch is of no use. I should put
hibernate_free_swap() before hibernation_snapshot().

I'll retry.

Thanks,
-Kame

