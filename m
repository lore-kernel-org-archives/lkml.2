Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1I1Udo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:33:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35934 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1I1Udn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:33:43 -0400
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1109271546320.13797@router.home>
References: <20110927175453.GA3393@albatros>
	 <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros>
	 <alpine.DEB.2.00.1109271459180.13797@router.home>
	 <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1109271546320.13797@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 13:31:45 -0700
Message-ID: <1317241905.16137.516.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11092820-6078-0000-0000-000001449A5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:47 -0500, Christoph Lameter wrote:
> On Tue, 27 Sep 2011, David Rientjes wrote:
> > It'll turn into another one of our infinite number of capabilities.  Does
> > anything actually care about statistics at KB granularity these days?
> 
> Changing that to MB may also break things. It may be better to have
> consistent system for access control to memory management counters that
> are not related to a process.

We could also just _effectively_ make it output in MB:

	foo = foo & ~(1<<20)

or align-up.  We could also give the imprecise numbers to unprivileged
users and let privileged ones see the page-level ones.

-- Dave

