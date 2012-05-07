Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2EGNjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:39:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42496 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab2EGNj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:39:28 -0400
Date: Mon, 7 May 2012 06:38:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 03/18] fork: Move thread info gfp flags to header
Message-ID: <20120507133836.GA16166@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120505150007.543515803@linutronix.de>
 <20120505150141.428211694@linutronix.de>
 <20120507043401.GA5406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507043401.GA5406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050713-6148-0000-0000-000005A0A32C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 09:34:01PM -0700, Paul E. McKenney wrote:
> On Sat, May 05, 2012 at 03:05:41PM -0000, Thomas Gleixner wrote:
> > These flags can be useful for extra allocations outside of the core
> > code.
> > 
> > Add __GFP_NOTRACE to them, so the archs which have kmemcheck do
> > not have to provide extra allocators just for that reason.
> 
> This breaks powerpc builds due to __GFP_NOTRACE not being defined.
> I restarted the test after removing the __GFP_NOTRACE as a testing-only
> hack, and will let you know how it goes.  Also looking into why this
> builds on 32-bit x86 but not on powerpc.

And the reason that it built on 32-bit x86 was that I mistakenly
built only the RCU files, not the whole kernel.  So I am guessing
that there is something I need to merge into tip/smp/hotplug.

On the other hand, removing the __GFP_NOTRACE allows this patchset to
pass modest rcutorture testing on Power.  ;-)

							Thanx, Paul

