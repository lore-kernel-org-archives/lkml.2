Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2E2Ri5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:38:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61886 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2E2Ri4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:38:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120529163849.GF21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-14-git-send-email-aarcange@redhat.com> <1338297385.26856.74.camel@twins>
 <20120529163849.GF21339@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 May 2012 10:38:34 -0700
X-Google-Sender-Auth: WtmBFWKI2rwE3GFXCPbINp2MgIY
Message-ID: <CA+55aFwmhM2a2HjB_MEjVDDL-AP4j-t202ozmHgT0azSptjnoA@mail.gmail.com>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 9:38 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Tue, May 29, 2012 at 03:16:25PM +0200, Peter Zijlstra wrote:
>> 24 bytes per page.. or ~0.6% of memory gone. This is far too great a
>> price to pay.
>
> I don't think it's too great, memcg uses for half of that and yet
> nobody is booting with cgroup_disable=memory even on not-NUMA servers
> with less RAM.

A big fraction of one percent is absolutely unacceptable.

Our "struct page" is one of our biggest memory users, there's no way
we should cavalierly make it even bigger.

It's also a huge performance sink, the cache miss on struct page tends
to be one of the biggest problems in managing memory. We may not ever
fix that, but making struct page bigger certainly isn't going to help
the bad cache behavior.

                    Linus
