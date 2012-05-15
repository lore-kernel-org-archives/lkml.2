Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2EOOFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:05:17 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51308 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2EOOFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:05:14 -0400
Date: Tue, 15 May 2012 16:04:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Luming Yu <luming.yu@gmail.com>,
        Nick Piggin <npiggin@gmail.com>, Alex Shi <alex.shi@intel.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        fweisbec@gmail.com, jeremy@goop.org, riel@redhat.com, luto@mit.edu,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org, jcm@jonmasters.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
Message-ID: <20120515140457.GB27806@aftab.osrc.amd.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
 <CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
 <CAJRGBZy0S_fg3GY4S5CG-2SWv5AG1jMrcMMqCiTg=7xyD1mrzQ@mail.gmail.com>
 <1337087170.27020.166.camel@laptop>
 <1337089145.14207.288.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337089145.14207.288.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 09:39:05AM -0400, Steven Rostedt wrote:
> > But you have to weight that against the cost of re-population, and
> > that's the difficult bit, since we have no clue how many tlb entries are
> > in use by the current cr3.
> > 
> > It might be possible for intel to give us this information, I've asked
> > for something similar for cachelines.
> 
> What information? The # of tlb entries in use?

... by the current %cr3, yes.

And also, before we delve into details, we still don't have a
representative benchmark where this shows any improvement.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
