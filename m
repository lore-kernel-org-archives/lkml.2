Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1BHRyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:54:41 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38811 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab1BHRyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:54:40 -0500
Subject: Re: [RFC][PATCH 0/6] more detailed per-process transparent
 hugepage statistics
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110202000750.GC16981@random.random>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201153857.GA18740@random.random> <1296580547.27022.3370.camel@nimitz>
	 <20110201203936.GB16981@random.random> <1296593801.27022.3920.camel@nimitz>
	 <20110202000750.GC16981@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 08 Feb 2011 09:54:34 -0800
Message-ID: <1297187674.6737.12145.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 01:07 +0100, Andrea Arcangeli wrote:
> > I guess we could also try and figure out whether the khugepaged CPU
> > overhead really comes from the scanning or the collapsing operations
> > themselves.  Should be as easy as some oprofiling.
> 
> Actually I already know, the scanning is super fast. So it's no real
> big deal to increase the scanning. It's big deal only if there are
> plenty more of collapse/split. Compared to the KSM scan, the
> khugepaged scan costs nothing.

Just FYI, I did some profiling on a workload that constantly split and
joined pages.  Very little of the overhead was in the scanning itself,
so I think you're dead-on here.

-- Dave

