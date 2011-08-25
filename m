Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1HYEta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:49:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1HYEt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:49:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eN8t1009jD6PyMz7ByUsyLU50jCX6NXFWeqX5M2YndjrVqArWIqzXUmy/OThPdpMH
	Af6/ovIPVoIjaYpMvGNFg==
MIME-Version: 1.0
In-Reply-To: <20110824045702.GA1674@kroah.com>
References: <20110815041524.GA7578@kroah.com>
	<CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
	<20110817045856.GB4936@kroah.com>
	<20110817132114.GB10209@sirena.org.uk>
	<CANqkERC2eyy3SQ6_vJncvuMdi=Yu=O8mZoXkggkX1q_4=d+q7g@mail.gmail.com>
	<20110824045702.GA1674@kroah.com>
Date: Wed, 24 Aug 2011 21:49:22 -0700
Message-ID: <CANqkERC9evgXzOMMiqtyvu3RsoUQWdUAh47yRNz1JjmB4Vydbg@mail.gmail.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
From: Brian Swetland <swetland@google.com>
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tim Bird <tbird20d@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stable-review@kernel.org, stable@kernel.org,
        tim.bird@am.sony.com,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 9:57 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Aug 17, 2011 at 10:33:05AM -0700, Brian Swetland wrote:
>> As far as long-term kernels goes, from the Android perspective we
>> strongly prefer to snap up to the most recent released kernel on every
>> platform/device release.  I prefer to be as up to date on bugfixes and
>> features from mainline as possible and minimize the deltas on our
>> stack 'o patches as much as possible.
>
> That's good to hear.
>
>> We've been getting more aggressive about merging in the -rc#s and then
>> rebasing on the final during development (before final stabilization
>> freeze for a release) in the last year or so, and it seems to work
>> pretty well.
>
> Is your kernel git tree public during this merge cycle so that others
> can track it?  I tried to dig through android.kernel.org but there are a
> lot of different kernel trees there :(

We really need a "which branch is which" quick guide that's easily
findable.  kernel/common is always where our generic patch stack
lives, and it looks like android-3.0 is the most recent (which has
3.0.1 merged in).

http://android.git.kernel.org/?p=kernel/common.git;a=summary

>> Not all OEMs or silicon vendors are as comfortable with this approach
>> and I expect some would welcome a long term tree they can count on to
>> get critical fixes for, though.  Device release teams (even our own,
>> for lead devices we work on) are notoriously risk-averse (often for
>> good reasons), and tend to get really nervous when they see the total
>> change count or diff stat for pulling up to a new kernel release close
>> to "final rom" for a product.
>
> That's understandable.
>
> So that kind of means they would like such a longterm tree, but they
> have the problem that your patches move forward to a newer kernel, but
> are not maintained for that longterm kernel.  Are they responsible for
> maintaining this themselves then, or do you help with providing your
> patchset on top of all of the different kernel versions that the OEMs
> and others need?

So far the silicon vendors have been doing more of the longer term
kernel stuff, as it better matches their model of providing "boxed"
stable BSPs of some sort.  It might make sense for us to ensure
backports of fixes for core patches (our common tree) are available
for the LT kernels, but we are unlikely to have the necessary staff to
maintain LT trees for every SoC we interact with.

Brian
