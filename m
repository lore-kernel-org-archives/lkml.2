Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab0FKWEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:04:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48922 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0FKWEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:04:46 -0400
Date: Fri, 11 Jun 2010 15:04:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
Message-ID: <20100611220443.GJ2394@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100611194016.GA5213@Krystal>
 <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
 <20100611203607.GH2394@linux.vnet.ibm.com>
 <4C12A539.1000709@zytor.com>
 <20100611213602.GI2394@linux.vnet.ibm.com>
 <4C12ACF3.8000007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C12ACF3.8000007@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 02:38:59PM -0700, H. Peter Anvin wrote:
> On 06/11/2010 02:36 PM, Paul E. McKenney wrote:
> > Memory barriers in the sequence-lock code prevent this, assuming, as
> > you point out, that memory clobber works (but if it doesn't, it should
> > be fixed):
> 
> The constness is my main concern.  It's not clear to me that "memory" is
> meant to imply that const memory areas without volatile can be clobbered.

Ah!  I was assuming that gcc treated "memory" as it would an call to
a function in some other compilation unit.  In that case, the compiler
could not count on the "const" on the argument, given the possibility
that the called function might gain a reference to the same memory
locations in a non-const manner, right?

							Thanx, Paul
