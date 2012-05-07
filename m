Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2EGTOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:14:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:41647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab2EGTOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:14:06 -0400
Date: Mon, 7 May 2012 21:14:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 03/18] fork: Move thread info gfp flags to header
In-Reply-To: <20120507043401.GA5406@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1205072112400.6271@ionos>
References: <20120505150007.543515803@linutronix.de> <20120505150141.428211694@linutronix.de> <20120507043401.GA5406@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2012, Paul E. McKenney wrote:

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

Hrmpf. Seems the idiot I am fatfingered __GFP_NOTRACK to __GFP_NOTRACE
and then only tested with the DEBUG stuff disabled......

