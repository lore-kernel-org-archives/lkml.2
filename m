Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1KUQsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:48:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34728 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1KUQsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:48:03 -0500
Date: Mon, 21 Nov 2011 08:47:58 -0800
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, pavel@ucw.cz,
        lenb@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
Message-ID: <20111121164758.GC15314@google.com>
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com>
 <201111192257.19763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111192257.19763.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Sat, Nov 19, 2011 at 10:57:19PM +0100, Rafael J. Wysocki wrote:
> > +	while (!mutex_trylock(&pm_mutex)) {
> > +		try_to_freeze();
> > +		msleep(10);
> 
> The number here seems to be somewhat arbitrary.  Is there any reason not to
> use 100 or any other number?

This is a bit moot at this point but, at least for me, yeah, it's a
number I pulled out of my ass.  That said, I think it's a good number
to pull out of ass for userland visible retry delays for the following
reasons.

* It's a good number - 10! which happens to match the number of
  fingers I have!  Isn't that just weird? @.@

* For modern hardware of most classes, repeating not-so-complex stuff
  every 10ms for a while isn't taxing (or even noticeable) at all.

* Sub 10ms delays usually aren't noticeable to human beings even when
  several of them are staggered.  This is very different when you get
  to 100ms range.

ie. going from 1ms to 10ms doesn't cost you too much in terms of human
noticeable latency (for this type of situations anyway) but going from
10ms to 100ms does.  In terms of computational cost, the reverse is
somewhat true too.  So, yeah, I think 10ms is a good out-of-ass number
for this type of delays.

Thanks.

-- 
tejun
