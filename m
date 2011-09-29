Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1I2EtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:49:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40475 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1I2EtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:49:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Sep 2011 13:48:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com,
        levinsasha928@gmail.com
Subject: Re: [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge
 at next window)
Message-Id: <20110929134816.7f29bf46.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <22173398-de03-43ef-abe4-a3f3231dd2e9@default>
References: <20110915213305.GA26317@ca-server1.us.oracle.com
 20110928151558.dca1da5e.kamezawa.hiroyu@jp.fujitsu.com>
	<22173398-de03-43ef-abe4-a3f3231dd2e9@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011 07:09:18 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > Sent: Wednesday, September 28, 2011 12:16 AM
> > To: Dan Magenheimer
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; jeremy@goop.org; hughd@google.com;
> > ngupta@vflare.org; Konrad Wilk; JBeulich@novell.com; Kurt Hackel; npiggin@kernel.dk; akpm@linux-
> > foundation.org; riel@redhat.com; hannes@cmpxchg.org; matthew@wil.cx; Chris Mason;
> > sjenning@linux.vnet.ibm.com; jackdachef@gmail.com; cyclonusj@gmail.com; levinsasha928@gmail.com
> > Subject: Re: [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at next window)
> > 
> > On Thu, 15 Sep 2011 14:33:05 -0700
> > Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > 
> > > [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at next window)
> > >
> > > (Note: V9->V10 only change is corrections in debugfs-related code/counters)
> > >
> > > (Note to earlier reviewers:  This patchset was reorganized at V9 due
> > > to feedback from Kame Hiroyuki and Andrew Morton.  Additionally, feedback
> > > on frontswap v8 from Andrew Morton also applies to cleancache, to wit:
> > >  (1) change usage of sysfs to debugfs to avoid unnecessary kernel ABIs
> > >  (2) rename all uses of "flush" to "invalidate"
> > > As a result, additional patches (5of6 and 6of6) were added to this
> > > series at V9 to patch cleancache core code and cleancache hooks in the mm
> > > and fs subsystems and update cleancache documentation accordingly.)
> > 
> > I'm sorry I couldn't catch following... what happens at hibernation ?
> > frontswap is effectively stopped/skipped automatically ? or contents of
> > TMEM can be kept after power off and it can be read correctly when
> > resume thread reads swap ?
> > 
> > In short: no influence to hibernation ?
> > I'm sorry if I misunderstand some.
> 
> Hi Kame --
> 
> Hibernation would need to be handled by the tmem backend (e.g. zcache, Xen
> tmem).  In the case of Xen tmem, both save/restore and live migration are
> fully supported.  I'm not sure if zcache works across hibernation; since
> all memory is kmalloc'ed, I think it should work fine, but it would be an
> interesting experiment.
> 

I'm afraid that users will lose data on memory of frontswap/zcache/tmem
by power-off, hibernation. How about adding internal hooks to disable/sync
frontswap itself before hibernation ? difficult ?

Thanks,
-Kame



