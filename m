Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab2D0OHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:07:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab2D0OHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:07:14 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Co6SMZqKBZgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGHU-0qZd6m6RciWSMoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335535630.28106.209.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v4 1/3] make jump_labels wait while updates are in place
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 27 Apr 2012 10:07:10 -0400
In-Reply-To: <20120427135320.GA13762@redhat.com>
References: <1335480667-8301-1-git-send-email-glommer@parallels.com>
	 <1335480667-8301-2-git-send-email-glommer@parallels.com>
	 <20120427004305.GC23877@home.goodmis.org>
	 <20120427135320.GA13762@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 09:53 -0400, Jason Baron wrote:

> Right, for x86 which uses stop_machine currently, we guarantee that all
> cpus are going to see the updated code, before the inc of key->enabled.
> However, other arches (sparc, mips, powerpc, for example), seem to be
> using much lighter weight updates, which I hope are ok :)

And x86 will soon be removing stop_machine() from its path too. But all
archs should perform some kind of memory sync after patching code. Thus
the update should be treated as if a memory barrier was added after it,
and before the inc.

-- Steve


