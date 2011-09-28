Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1I1OKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:10:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43919 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1I1OKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:10:10 -0400
MIME-Version: 1.0
Message-ID: <22173398-de03-43ef-abe4-a3f3231dd2e9@default>
Date: Wed, 28 Sep 2011 07:09:18 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com,
        levinsasha928@gmail.com
Subject: RE: [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at
 next window)
References: <20110915213305.GA26317@ca-server1.us.oracle.com
 20110928151558.dca1da5e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110928151558.dca1da5e.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090203.4E832AAF.00DD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Sent: Wednesday, September 28, 2011 12:16 AM
> To: Dan Magenheimer
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; jeremy@goop.org; hughd@google.com;
> ngupta@vflare.org; Konrad Wilk; JBeulich@novell.com; Kurt Hackel; npiggin@kernel.dk; akpm@linux-
> foundation.org; riel@redhat.com; hannes@cmpxchg.org; matthew@wil.cx; Chris Mason;
> sjenning@linux.vnet.ibm.com; jackdachef@gmail.com; cyclonusj@gmail.com; levinsasha928@gmail.com
> Subject: Re: [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at next window)
> 
> On Thu, 15 Sep 2011 14:33:05 -0700
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at next window)
> >
> > (Note: V9->V10 only change is corrections in debugfs-related code/counters)
> >
> > (Note to earlier reviewers:  This patchset was reorganized at V9 due
> > to feedback from Kame Hiroyuki and Andrew Morton.  Additionally, feedback
> > on frontswap v8 from Andrew Morton also applies to cleancache, to wit:
> >  (1) change usage of sysfs to debugfs to avoid unnecessary kernel ABIs
> >  (2) rename all uses of "flush" to "invalidate"
> > As a result, additional patches (5of6 and 6of6) were added to this
> > series at V9 to patch cleancache core code and cleancache hooks in the mm
> > and fs subsystems and update cleancache documentation accordingly.)
> 
> I'm sorry I couldn't catch following... what happens at hibernation ?
> frontswap is effectively stopped/skipped automatically ? or contents of
> TMEM can be kept after power off and it can be read correctly when
> resume thread reads swap ?
> 
> In short: no influence to hibernation ?
> I'm sorry if I misunderstand some.

Hi Kame --

Hibernation would need to be handled by the tmem backend (e.g. zcache, Xen
tmem).  In the case of Xen tmem, both save/restore and live migration are
fully supported.  I'm not sure if zcache works across hibernation; since
all memory is kmalloc'ed, I think it should work fine, but it would be an
interesting experiment.

Thanks,
Dan
