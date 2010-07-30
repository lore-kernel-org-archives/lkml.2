Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab0G3ET3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:19:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50212 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0G3ET1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:19:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Jul 2010 13:14:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 21:10:10 -0700
Hugh Dickins <hughd@google.com> wrote:

> On Thu, Jul 29, 2010 at 5:01 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > I think the best way is kexec(). But maybe rollback from hibernation failure
> > will be difficult. Considering how crash-dump works well and under maintainance
> > by many enterprise guys, hibernation-by-kexec is a choice. I think. It can make
> > reuse of kdump code, ...or, hibernation-resume code can eat kdump image
> > directly. Maybe the problem will be the speed of dump.
> 
> I've no appetite for a total rework of hibernation, and I don't see
> how that would
> address the issue: I'm just looking for some protection against swap
> reuse danger.
> 
Okay ;) (And I forget that kexec has to prepare memory at boot time for 2nd kernel.
It will be harmful for small device guys.)

I'll prepare a routine not-quick-fix.
BTW, after reading mail between you and Andrea, kernel threads are not guaranteed
to be stopped when memory-dump is running ?

-Kame

