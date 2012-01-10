Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2AJIw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:52:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2AJIw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:52:56 -0500
Date: Tue, 10 Jan 2012 09:52:53 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefiles: Disable unused-variable warning
Message-ID: <20120110085253.GC5050@tiehlicka.suse.cz>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <20111227135752.GK5344@tiehlicka.suse.cz>
 <4F09AFBD.60503@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F09AFBD.60503@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 08-01-12 16:01:17, Michal Marek wrote:
> Dne 27.12.2011 14:57, Michal Hocko napsal(a):
> > Anyway, I am wondering why unused-but-set-variable is disabled while
> > unused-variable is enabled.
> 
> unused-but-set-variable was disabled, because it was a new warning in
> gcc 4.6 and produced too much noise relatively to its severity. A make
> W=1 build of x86_64_defconfig gives:
> $ grep -c 'Wunused-but-set-variable' log
> 77
> $ grep -c 'Wunused-variable' log
> 0
> 
> More exotic configuration will probably result in a couple of unused
> variable warnings, but that IMO no reason to disable them globally.

OK.

> > Shouldn't we just disable it as well rather
> > than workaround this in the code? The warning is just pure noise in this
> > case.
> 
> If it's noise in a particular case, there is always the option to add
> 
> CFLAGS_memcontrol.o := $(call cc-disable-warning, unused-variable)

I would like to prevent from local cflags hacks. Moreover the code will
go away so I guess it doesn't make much sense to play tricks here.

> 
> to the respective Makefile.
> 
> Michal

Thanks

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
