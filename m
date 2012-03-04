Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2CDRi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 12:38:29 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44317 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2CDRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 12:38:27 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH -V2 1/9] mm:  move hugetlbfs region tracking function to common code
In-Reply-To: <20120301143345.7e928efe.akpm@linux-foundation.org>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1330593380-1361-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120301143345.7e928efe.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 04 Mar 2012 23:07:50 +0530
Message-ID: <87linge07l.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12030407-0260-0000-0000-000000A4AFD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012 14:33:45 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  1 Mar 2012 14:46:12 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > This patch moves the hugetlbfs region tracking function to
> > common code. We will be using this in later patches in the
> > series.
> > 
> > ...
> >
> > +struct file_region {
> > +	struct list_head link;
> > +	long from;
> > +	long to;
> > +};
> 
> Both Andrea Righi and John Stultz are working on (more sophisticated)
> versions of file region tracking code.  And we already have a (poor)
> implementation in fs/locks.c.
> 
> That's four versions of the same thing floating around the place.  This
> is nutty.


We should be able to remove region.c once other alternatives are in
upstream. I will also look at the alternatives and see if it would need
any change to make it usable for this work.

Thanks,
-aneesh

