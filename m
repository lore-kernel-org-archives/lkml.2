Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1L0Na0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 08:30:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab1L0NaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 08:30:24 -0500
Date: Tue, 27 Dec 2011 14:30:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: hugetlb: add might_sleep() for gigantic page
Message-ID: <20111227133021.GI5344@tiehlicka.suse.cz>
References: <CAJd=RBCXTp0GrMGw+MBDdj0K15+L5v+O2t6EcDghFk34aNwt1g@mail.gmail.com>
 <20111227125945.GH5344@tiehlicka.suse.cz>
 <CAJd=RBA70k8pCoP26hoJua=h1DHgx7eLHU0qrukJRxwoaxB65Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBA70k8pCoP26hoJua=h1DHgx7eLHU0qrukJRxwoaxB65Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-12-11 21:21:18, Hillf Danton wrote:
> On Tue, Dec 27, 2011 at 8:59 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Fri 23-12-11 21:41:08, Hillf Danton wrote:
> >> From: Hillf Danton <dhillf@gmail.com>
> >> Subject: [PATCH] mm: hugetlb: add might_sleep() for gigantic page
> >>
> >> Like the case of huge page, might_sleep() is added for gigantic page, then
> >> both are treated in same way.
> >
> > Why do we need to call might_sleep here? There is cond_resched in the
> > loop...
> >
> 
> IIUC it is the reason to add... and the comment says

cond_resched calls __might_sleep so there is no reason to call
might_sleep outside the loop as well.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
