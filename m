Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2GWE2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 00:28:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54228 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751691Ab2GWE2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 00:28:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ofX1TLWFonZltYe+F3SaRcAg7yVms7iuLPsY70O
	KUEqhMhMWDnp/e
Message-ID: <1343017683.7336.67.camel@marge.simpson.net>
Subject: Re: [PATCH 0/5] cpusets: dynamical scheduler domain flags
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, paul@paulmenage.org
Date: Mon, 23 Jul 2012 06:28:03 +0200
In-Reply-To: <500CB763.9020802@linux.vnet.ibm.com>
References: <50052A78.6000407@linux.vnet.ibm.com>
	 <1342802550.2583.12.camel@twins> <500CB763.9020802@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 10:30 +0800, Michael Wang wrote: 
> On 07/21/2012 12:42 AM, Peter Zijlstra wrote:
> > On Tue, 2012-07-17 at 17:03 +0800, Michael Wang wrote:
> >> This patch set provide a way for user to dynamically configure the scheduler
> >> domain flags, which usually to be static. 
> > 
> > NAK.. you don't get to expose all this nonsense in a 'stable' ABI.
> > 
> > You shouldn't need to prod at them to begin with.
> 
> So is that means expose those domain flags to user is a bad idea at all?

You can set/clear flags with scripts now, ie domain flags are already
exposed.. as defined by the running kernel.

SD_SHARE_PKG_RESOURCES is a good flag look at.  What does flipping that
switch do, and what did it stop doing recently?  So yeah, methinks
exporting flags via cpusets is a bad idea.  Not only is existence of any
particular flag volatile, functionality behind it is volatile as well,
so having a button to poke does undefined things.  (not to mention
non-exclusive sets)

-Mike


