Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab2EJKlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:41:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54829 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2EJKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:41:12 -0400
Date: Thu, 10 May 2012 12:40:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 4/7] x86/tlb: fall back to flush all when meet a THP
 large page
Message-ID: <20120510104058.GA31257@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-5-git-send-email-alex.shi@intel.com>
 <1336642145.2527.79.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336642145.2527.79.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:29:05AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
> > We don't need to flush large pages by PAGE_SIZE step, that just waste
> > time. and actually, large page don't need 'invlpg' optimizing according
> > to our macro benchmark. So, just flush whole TLB is enough for them.
> > 
> > The following result is tested on a 2CPU * 4cores * 2HT NHM EP machine,
> > with THP 'always' setting.
> 
> What does it do when you disable THP? That has_large_page() thing is a
> massive amount of pointer chasing..

Yeah, this looks like a bit of a overhead. Don't we have some per-mm
accounting of whether that mm struct has hugepages in mm/huge_memory.c,
i.e. something like what collapse_huge_page() does, for example, at the
end by incrementing khugepaged_pages_collapsed but in a per-mm variable?

And make this part of the THP code so we get it for free here.

Is Andrea on the CC list... hm, no, CCed.

Andrea?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
