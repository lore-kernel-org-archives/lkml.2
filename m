Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0CRQyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:54:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44552 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab0CRQyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:54:33 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Steven Munroe <munroesj@linux.vnet.ibm.com>
Reply-To: munroesj@us.ibm.com
To: Andreas Schwab <schwab@redhat.com>
Cc: munroesj@us.ibm.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
In-Reply-To: <m37hp9y51p.fsf@hase.home>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com> <4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com> <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
	 <1268785874.2335.137.camel@pasglop> <4BA06E1B.2040706@redhat.com>
	 <1268816179.2335.187.camel@pasglop> <4BA11FD2.2090104@zytor.com>
	 <1268858134.2335.198.camel@pasglop> <4BA1412C.6070008@zytor.com>
	 <1268866720.2335.204.camel@pasglop>
	 <1268928480.19726.123.camel@spokane1.rchland.ibm.com>
	 <m37hp9y51p.fsf@hase.home>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 18 Mar 2010 12:03:43 -0500
Message-Id: <1268931823.19726.127.camel@spokane1.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 17:21 +0100, Andreas Schwab wrote:
> Steven Munroe <munroesj@linux.vnet.ibm.com> writes:
> 
> > extern long int syscall (long int __sysno, ...) __THROW;
> >
> > #endif	/* Use misc.  */
> >
> > Changing this would be an ABI change and would have to be versioned. It
> > would effect any one using syscall not just SYS_fallocate.
> >
> > the question is do programmers in practice include unistd.h when they
> > use syscall.
> >
> > If the changed prototype is not in scope then the 1st parm (__sysno)
> > defaults to int and is passed in on r3 which gets moved to r0.
> 
> int is incompatible with long, so you already get undefined behaviour
> anyway.
> 
Sorry in and long are compatible in 32-bit but not long long.

int and long are not compatible in 64-bit

It is hard the keep all the nodes and arguments straight.

But the concern about changing the prototype and are people actually
using the prototype are still valid.

> Andreas.
> 

