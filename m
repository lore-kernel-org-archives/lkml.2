Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2EXGEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:04:24 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33369 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2EXGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:04:22 -0400
Date: Thu, 24 May 2012 08:04:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@suse.com>, borislav.petkov@amd.com,
        arnd@arndb.de, akinobu.mita@gmail.com, eric.dumazet@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, hughd@google.com,
        jeremy@goop.org, len.brown@intel.com, tony.luck@intel.com,
        yongjie.ren@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
        seto.hidetoshi@jp.fujitsu.com, penberg@kernel.org, yinghai@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, ak@linux.intel.com,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings of
 SMT
Message-ID: <20120524060453.GC25344@aftab.osrc.amd.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
 <4FBD18D20200007800085951@nat28.tlf.novell.com>
 <1337792984.9783.37.camel@laptop>
 <1337793338.9783.38.camel@laptop>
 <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>
 <4FBDC34E.5090905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBDC34E.5090905@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:12:46PM +0800, Alex Shi wrote:
> On 05/24/2012 09:46 AM, Andrew Lutomirski wrote:
> 
> > On Wed, May 23, 2012 at 10:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> On Wed, 2012-05-23 at 19:09 +0200, Peter Zijlstra wrote:
> >>>> There is no comment or anything else indicating that this is
> >>>> suitable for dual-thread CPUs only - when there are more than
> >>>> 2 threads per core, the intended effect won't be achieved.
> >>>
> >>> Why would that be? Won't higher thread count still share the same
> >>> resources just more so?
> >>
> >> Ah, I see, you're saying his code is buggy for >2 threads. Agreed.
> >>
> > 
> > An evil knob to statically choose which SMT sibling gets the interrupt
> > would be nice.  Then my compute-intensive thread could be (mostly)
> > unaffected by the other thread on a different core that calls munmap
> > frequently.
> 
> How to know we are in such situation? :)

Please, not yet another knob, we have too many as it is.

Can't you figure this out from the topology, smt siblings or whatever
this is called:

/sys/devices/system/cpu/cpu0/topology/thread_siblings

?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
