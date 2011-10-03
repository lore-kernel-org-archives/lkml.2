Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1JCNOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1JCNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:14:18 -0400
Date: Mon, 3 Oct 2011 09:13:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20111003131328.GW5795@redhat.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
 <1316805435-14832-5-git-send-email-dzickus@redhat.com>
 <20110928103140.GD6063@erda.amd.com>
 <20110928123720.GL5795@redhat.com>
 <4E8837D4.5040607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8837D4.5040607@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 12:07:16PM +0200, Avi Kivity wrote:
> >Right.  Avi, Jeremy what was your objection that needed this optimization
> >in the first place?
> >
> 
> First, iterating over all NMI sources is going to be slow, and a lot
> more so in a guest.  This reduces the performance of perf.

I understand and agree.  The only positive I can offer is most machines
will most likely only have two NMI handlers registered: perf and
arch_backtrace.  So any slowness should be minimal.  We might even be able
to code up arch_backtrace to register its NMI handler when it is called to 
minimize the the number of NMI sources even more.

Cheers,
Don

> 
> Second, I wanted to use NMIs as a way of waking up a vcpu sleeping
> with interrupts disabled (in the context of Jeremy's paravirt
> spinlock patches).  Looks like we'll have to use paravirtualization
> for that.


> 
> -- 
> error compiling committee.c: too many arguments to function
> 
