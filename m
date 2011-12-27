Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1L0DT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 22:19:26 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48152 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1L0DTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 22:19:18 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <87vcp4t45p.fsf@linux.vnet.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 27 Dec 2011 08:45:06 +0530
Message-ID: <877h1iu2md.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122703-5816-0000-0000-0000009ADD57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011 08:44:58 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> On Sun, 25 Dec 2011 12:58:15 +0200, Avi Kivity <avi@redhat.com> wrote:
> > On 12/23/2011 12:36 PM, Ingo Molnar wrote:
> > > * Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > >
> [...]
> > > > 
> > > > I see the main difference between both the reports is:
> > > > native_flush_tlb_others.
> > >
> > > So it would be important to figure out why ebizzy gets into so 
> > > many TLB flushes and why gang scheduling makes it go away.
> > 
> > The second part is easy - a remote tlb flush involves IPIs to many other
> > vcpus (possible waking them up and scheduling them), then busy-waiting
> > until they acknowledge the flush.  Gang scheduling is really good here
> > since it shortens the busy wait, would be even better if we schedule
> > halted vcpus (see the yield_on_hlt module parameter, set to 0). 
> I will check this.
> 
I am seeing a drop of ~44% when setting yield_on_hlt = 0

Nikunj

