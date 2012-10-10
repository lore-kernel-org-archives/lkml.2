Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2JJNGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:06:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:42439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2JJNGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:06:07 -0400
Message-ID: <1349874355.1279.16.camel@twins>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Oct 2012 15:05:55 +0200
In-Reply-To: <20121010122921.GX29125@suse.de>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de>
	 <1349170282.7086.56.camel@marge.simpson.net>
	 <20121002131421.GN29125@suse.de>
	 <1349247011.4465.24.camel@marge.simpson.net>
	 <1349251997.4465.42.camel@marge.simpson.net>
	 <1349271001.4465.66.camel@marge.simpson.net>
	 <20121010122921.GX29125@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 13:29 +0100, Mel Gorman wrote:
> Do we really switch more though?
> 
> Look at the difference in interrupts vs context switch. IPIs are an interrupt
> so if TTWU_QUEUE wakes process B using an IPI, does that count as a context
> switch?

Nope. Nor would it for NO_TTWU_QUEUE. A process waking another is just
that, a wakeup.

A context switch is when we stop running a process and start running
anther. A wakeup can lead to us deciding the newly woken task is a
better task to run, however its not a given.

