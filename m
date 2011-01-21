Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1AURqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:46:12 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:29441 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750786Ab1AURqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:46:11 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3Y_SWowVM1mXXHSJCCr9ZAknSflYq1mhbDIOpFIa5sUMBV9
 F6Mn2BWfgBgDdrP7pKrCa_D4_nAnKWIQJQtiLFBkbR8eV1SkdEWe1HC1g_qQ
 6zD24qeSSNB5IgEs938VZNv1CoIQfnKTgm6gPzHtuWj58NuGFxHoNdLA4L5E
 oSUFbVmuhaIQfIij_ffAgafn2WOkUxUoUlkNkCPxmzLKvtqVJmZZOoyMjWqq
 L5CdUpBJSD94LRR1IDOetabP7tLpkgaDQscaGUuUlTIK7zSy13Wg0nPkeTI0
 YpZs03z8vCfdHWi3w9xKSHA_NXUvgIM7wbFEoFvYfy.CHZJQ-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 11:46:04 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
In-Reply-To: <20110121172836.GK2832@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101211139330.15692@router.home>
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20110121171133.GI2832@htj.dyndns.org> <alpine.DEB.2.00.1101211114530.15692@router.home> <20110121172836.GK2832@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Tejun Heo wrote:

> On Fri, Jan 21, 2011 at 11:21:02AM -0600, Christoph Lameter wrote:
> > > I don't think percpu_read_stable() can be used here.  It's not
> > > guaranteed to be stable across different cpus.
> >
> > Why would that matter? The caller has to disabled preemption anyways since
> > otherwise the processor may change which means that the result of the
> > operation is useless.
>
> Because
>
> 	preempt_disable();
> 	this_cpu_has();
> 	preempt_enable();
> 	preempt_disable();
> 	this_cpu_has();
> 	preempt_enable();
>
> might malfunction.  percpu_read_stable() is pretty much applicable
> only to stuff local to the thread.

Ok then lets change it to percpu_read

> > > Also, can we just implement what's necessary on top of this_cpu_has()?
> > > this_cpu_has() already has constant handling, so there's no need to
> > > add this_cpu_test_bit() at this point.
> >
> > Not sure what you mean. this_cpu_test_bit is necessary because
> > test_cpu_cap expects a regular pointer and performs a regular load.
> > this_cpu_constant_test_bit handles the segment prefix necessary for a per
> > cpu load.
> >
> > The constant refers to the bit.
>
> Oh, you're right.  Sorry about that.  Can you please then add a
> comment noting that the operation is x86 only?  Maybe prefix it with
> x86_?

For a function defined in an specific include file and only used in arch
specific code?
