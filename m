Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1LSMFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:05:45 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37572 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1LSMFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:05:43 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EEF2729.6080501@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <4EEF2382.4010605@redhat.com> <87hb0wbx0p.fsf@abhimanyu.in.ibm.com> <4EEF2729.6080501@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 19 Dec 2011 17:36:52 +0530
Message-ID: <87ehw0bw9v.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121902-3568-0000-0000-000000E8C8A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 13:59:37 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/19/2011 01:50 PM, Nikunj A Dadhania wrote:
> > On Mon, 19 Dec 2011 13:44:02 +0200, Avi Kivity <avi@redhat.com> wrote:
> > > On 12/19/2011 01:23 PM, Ingo Molnar wrote:
> > > > What's behind this huge speedup? Does ebizzy use user-space 
> > > > spinlocks perhaps? Could we do something on the user-space side 
> > > > to get a similar speedup?
> > > 
> > > kvm tries to detect spinlocks (by trapping repeated executions of PAUSE)
> > > and yield to a related vcpu.  It's far from perfect however, and relies
> > > on the spinlock code using PAUSE.
> > > 
> > Avi, is this soft-PLE kind of thing?
> 
> No, hard PLE, see the calls to yield_to.
> 
The above ebizzy result is from a non-PLE machine, will yield_to come
in to picture here?

I have two set of results, one for PLE machine and other for non-PLE.

Nikunj

