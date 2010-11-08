Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0KHTj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:39:57 -0500
Received: from www.tglx.de ([62.245.132.106]:50599 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab0KHTjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:39:55 -0500
Date: Mon, 8 Nov 2010 20:39:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>, mingo@elte.hu,
        eric.dumazet@gmail.com, jkacur@redhat.com,
        Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 3/3] futex: add futex_q static initializer
In-Reply-To: <1289239951.2191.0.camel@laptop>
Message-ID: <alpine.LFD.2.00.1011082037200.2900@localhost6.localdomain6>
References: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>  <1288216466-14309-4-git-send-email-dvhart@linux.intel.com>  <alpine.LFD.2.00.1011081724460.2900@localhost6.localdomain6> <1289239951.2191.0.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010, Peter Zijlstra wrote:

> On Mon, 2010-11-08 at 17:42 +0100, Thomas Gleixner wrote:
> > > +#define FUTEX_Q_INIT \
> > > +     { /* list gets initialized in queue_me()*/ \
> > > +       .task = NULL, NULL, FUTEX_KEY_INIT \
> > > +     , NULL, NULL, NULL, FUTEX_BITSET_MATCH_ANY }
> > > +
> > 
> > That should be a static readonly variable with a proper C99
> > initializer. 
> 
> Well, it doesn't need to actually be an existing variable, but yeah it
> should definately use C99 initializers.

If you have multiple instances of q = q_init; the static variable is
more efficient vs. code/data size 

Thanks,

	tglx


