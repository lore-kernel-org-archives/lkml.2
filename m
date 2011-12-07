Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1LGGdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:33:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53924 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1LGGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:33:13 -0500
Date: Wed, 7 Dec 2011 10:33:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111207063308.GC20459@moon>
References: <20111205182010.GV14515@moon>
 <20111206140833.3b43fbeb.akpm@linux-foundation.org>
 <20111206221515.GP29781@moon>
 <20111206225315.GA20459@moon>
 <20111207090259.e2296dd3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207090259.e2296dd3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 09:02:59AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 7 Dec 2011 02:53:15 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>  
> > Index: linux-2.6.git/Documentation/filesystems/proc.txt
> > ===================================================================
> > --- linux-2.6.git.orig/Documentation/filesystems/proc.txt
> > +++ linux-2.6.git/Documentation/filesystems/proc.txt
> > @@ -305,6 +305,9 @@ Table 1-4: Contents of the stat files (a
> >    blkio_ticks   time spent waiting for block IO
> >    gtime         guest time of the task in jiffies
> >    cgtime        guest time of the task children in jiffies
> > +  start_data    address above which program data is placed
> > +  end_data      address above which program data is placed
> > +  start_brk     address above which program data can be expanded with brk() call
> >  ..............................................................................
> > 
> nitpick.
> 
> After reading Wikipedia, http://en.wikipedia.org/wiki/Data_segment
> 
> I prefer
> 
> start_data   address above program data+bss is placed.
> end_data     address below program data+bss is placed
> start_break  address above which program heap can be expaned with brk() call
> 
> rather than just 'data'. 
> 

No problem, I'll update (These segments are filled by binfmt handlers).

	Cyrill
