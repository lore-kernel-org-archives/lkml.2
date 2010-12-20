Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0LTB3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:29:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:34878 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab0LTB3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:29:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,198,1291622400"; 
   d="scan'208";a="869898192"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D09E0EE.7040605@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
	 <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>
	 <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe>
	 <4D08CBF4.6040102@gmail.com> <1292460817.2323.465.camel@sli10-conroe>
	 <20101216054620.GA3241@merkur.ravnborg.org>
	 <1292479000.2323.468.camel@sli10-conroe>  <4D09E0EE.7040605@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 09:28:38 +0800
Message-ID: <1292808518.10593.8.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 17:50 +0800, Tejun Heo wrote:
> Hello, Shaohua.
> 
> On 12/16/2010 06:56 AM, Shaohua Li wrote:
> >>>>> -#include <asm-generic/vmlinux.lds.h>
> >>>>>  #include <asm/asm-offsets.h>
> >>>>>  #include <asm/thread_info.h>
> >>>>>  #include <asm/page_types.h>
> >>>>>  #include <asm/cache.h>
> >>>>> +#include <asm-generic/vmlinux.lds.h>
> >>>>>  #include <asm/boot.h>
> >>>>
> >>>> Why do we need this chunk?
> >>> the cache size is defined in cache.h, so I need move vmlinux.lds.h after
> >>> cache.h
> >>
> >> The right fix is to move the inclusion of cache.h to
> >> asm-generic/vmlinux.lds.h.  A quick audit only found sparc that
> >> failed to guard non assembler stuff.
> >
> > with this, we need check every arch, at least doing a compile. I'm
> > afraid I can't, sorry.
> 
> Not being able to cross build every arch is okay but you at least need
> to make an effort to make things easily applicable to other archs and
> avoid adding subtle ugliness like the above.  Please at least try to
> look at other arch codes and see how things can be made to work across
> different archs.  Setting up cross compilers for the major archs, for
> example, sparc, power and ia64 isn't that difficult either.
This still needs I fix every arch, for example, as Sam pointed out,
spark build will fail. I really have the bandwidth and capability to do
this. Increment changes are always preferred. My original patch is
trying to follow increment changes way.

