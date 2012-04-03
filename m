Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2DCX0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:26:22 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43344 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2DCX0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:26:21 -0400
Date: Tue, 3 Apr 2012 16:26:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
Message-ID: <20120403232617.GA733@kroah.com>
References: <20120402213440.49e9de74@neptune>
 <1333401898.2960.78.camel@laptop>
 <1333403193.2960.80.camel@laptop>
 <20120403060252.GA27084@gmail.com>
 <20120403081735.78ca3bb3@pluto.restena.lu>
 <m1d37pgugy.fsf@fess.ebiederm.org>
 <20120403071543.GA17502@gmail.com>
 <m1r4w5dzjq.fsf@fess.ebiederm.org>
 <1333463264.2960.99.camel@laptop>
 <m1aa2s2yex.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aa2s2yex.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 04:22:46PM -0700, Eric W. Biederman wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Tue, 2012-04-03 at 00:50 -0700, Eric W. Biederman wrote:
> >> 
> >> So I am asking that since perf is built in a way that actively makes
> >> debugging these kinds of problems hard that you please add additional
> >> debugging code to perf_pmu_register or some other better location so
> >> that simply registering something buggy with perf will show the bug.
> >> 
> >> 
> > Is there a convenient helper function that we can use that validates the
> > attribute_group structure? We could use such a function to do the
> > validation at a point where we still know where it came from.
> 
> There isn't but I was just thinking before you sent this that we could
> really use one.

Let me look into this some more, the driver core really should be
protecting you from doing something like this here, sysfs shouldn't be
getting involved (not to say that the patch is incorrect, it isn't, I'll
queue it up, but that something more looks to be needed to keep from
hitting that problem in the first place.)

thanks,

greg k-h
