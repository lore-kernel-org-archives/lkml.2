Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0HYAmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:42:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52012 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0HYAmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:42:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 09:37:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100825093747.24085b28.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
	<20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:34:38 -0700
Paul Menage <menage@google.com> wrote:

> On Tue, Aug 24, 2010 at 5:20 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Hmm, sure. I'll change the ->create() interface.  O.K. ?
> >
> 
> Hmm. An alternative (possibly cleaner) would be:
> 
> 1) add a css_size field in cgroup_subsys that contains the size of the
> per-subsystem structure
> 2) change cgroups to allocate and populate the css *before* calling
> create(), since it now knows the actual size
> 3) simplify all the subsystem create() methods since they no longer
> have to worry about allocation or out-of-memory handling
> 4) also add a top_css field in cgroups that allows cpusets to use the
> statically-allocated top_cpuset since it's initialized prior to memory
> allocation being reliable
> 
> This avoids us having to pass in any new parameters to the create()
> method in future since they can be populated in the CSS.
> 

Ou...I'm sorry but I would like to use attach_id() for this time.
Forgive me, above seems a big change.
I'd like to write a series of patch to do above, later.
At least, to do a trial.

Thanks,
-Kame

