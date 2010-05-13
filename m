Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab0EMSSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:18:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab0EMSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:18:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=xsjQEJMQsUKeqmi3+GvG6x7L4E2xnSvn7d6/NarAPeggp+xqhcyAyyp3HGIf6cVw8
	OQGVu4AnNmJFmeh4VCaeA==
MIME-Version: 1.0
In-Reply-To: <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	 <20100513121745.GA10749@srcf.ucam.org>
	 <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com>
Date: Thu, 13 May 2010 11:17:56 -0700
Message-ID: <s2ga55d774e1005131117yd138c59bk54cc109401eb4a8d@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Matthew Garrett <mjg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?Q?Beno=C3=AEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:33 AM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Thu, 2010-05-13 at 13:17 +0100, Matthew Garrett wrote:
>> On Wed, May 12, 2010 at 09:35:30PM -0600, Paul Walmsley wrote:
>> >
>> > Figuring out a different way to do this should not limit Android at all,
>> > since Google can do what other Linux distributions do and continue to
>> > patch opportunistic suspend/suspend-block calls into their kernels as
>> > needed to ship devices, while contributing towards a different solution to
>> > the problem.
>>
>> I basically agree, except that despite having a year to do so none of us
>> have come up with a different way that would actually work. Google have
>> done this work. Who's going to prove that there is actually a different
>> way to do this?
>
> We all feel the pain of inelegance right? I think it's clear that this
> system will not last (but there's no other immediate option) .. That
> doesn't mean we should reject it, but we need to be clear that this
> system will get replaced. So we should format the patches appropriately.
> To me the userspace aspect is a permanent change .. If we could drop
> that (or put it into debugfs) then it would make this a lot easy to
> accept as a stepping stone.

I'm in agreement on the first half of this -- from the Google/Android
point of view, if we can someday accomplish everything we need with
some different facility, we'll happily shift over to that.  That seems
like a normal operating mode for mainline -- new solutions arise,
drivers are migrated to those new solutions, old solutions fall to the
wayside.  We fully expect that the world will change over time and one
of our largest goals with trying to get work upstream is to reduce the
pain of those changes for everyone, while trying to get to "you can
build a kernel out of the box from mainline that Just Works with an
android userspace".

I'm not sure this necessitates using only debugfs for the userspace
interface.  A userspace interface is necessary to accomplish what
we're trying to do here, otherwise we have only half a solution, and
our hope is that it'd be a stable interface (as userspace interfaces
are supposed to be) for as long as its needed.  I could totally
imagine the userspace interface eventually becoming a no-op or
punching through to some other facility, depending on how this problem
is solved long-term in the ideal post-suspend-block future.

Brian
