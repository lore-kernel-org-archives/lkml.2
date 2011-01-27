Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1A0PEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:04:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab1A0PEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:04:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1101262130450.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101262130450.31804@localhost6.localdomain6> <20110126195810.247325792@linutronix.de> <20110126195833.970840140@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: Re: rwsem: rwsem: Remove redundant asmregparm annotation
Date: Thu, 27 Jan 2011 15:03:40 +0000
Message-ID: <19896.1296140620@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
> compiling the kernel already with -mregparm=3. So the annotation of
> the rwsem functions is redundant. Remove it.

That's fine - as long as we never remove the -mregparm=3 on i386.  The inline
assembly relies on the regparm=3 calling convention.

David
