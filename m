Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0EMX2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:28:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0EMX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:28:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fuOau9uoN75ibWF1ZX28IMP5czYmAAsQxJvrggIYjcI7JncwlWb+FQijyPXdDhpjO
	CGGq0BF8zm1aBve2DcuuA==
MIME-Version: 1.0
In-Reply-To: <20100513224600.GB23014@suse.de>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <201005132311.26293.rjw@sisk.pl>
	 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
	 <201005132327.16163.rjw@sisk.pl>
	 <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
	 <20100513214653.GA21120@suse.de>
	 <13B9B4C6EF24D648824FF11BE896716203BB0EEAE9@dlee02.ent.ti.com>
	 <20100513224600.GB23014@suse.de>
Date: Thu, 13 May 2010 16:28:23 -0700
Message-ID: <s2wa55d774e1005131628v107b339fo7f1da3816a22c5c0@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Greg KH <gregkh@suse.de>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Daniel Walker <dwalker@fifo99.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       "Cousson, Benoit" <b-cousson@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 3:46 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, May 13, 2010 at 05:33:58PM -0500, Woodruff, Richard wrote:
>>
>> > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> > owner@vger.kernel.org] On Behalf Of Greg KH
>> > Sent: Thursday, May 13, 2010 4:47 PM
>>
>> > Also note that such a driver, without wakelocks, would never get tested,
>> > and so, things start quickly diverging.
>>
>> Do wakelock enabled drivers require a wakelock aware user space to
>> function properly?
>
> Not that I can tell, but others might know more.

Drivers with correct wakelock usage will play nice with opportunistic suspend.

If you're not using opportunistic suspend, you probably don't need
wakelocks at all, and the driver (unless it's broken) should work just
fine for you.

>> If the driver is added you want to make sure the benefit is there and
>> testable for all userspaces.
>
> Agreed.

Definitely.  The fact that say the dsp audio driver or serial driver
on MSM use wakelocks to play nice with opportunistic suspend should
have no impact on, say, Debian-on-G1 which is not using that feature.
Debian would still be able to play audio or write to the serial port.

With wakelock support in the kernel, I'm able to maintain drivers that
(provided they meet the normal style, correctness, etc requirements)
that both can be submitted to mainline (yay!) and can ship on
production hardware as-is (yay!).  Porting other linux based
environments to hardware like G1, N1, etc becomes that much easier
too, which hopefully makes various folks happy.

This helps get us ever closer to being able to build a
production-ready kernel for various android devices "out of the box"
from the mainline tree and gets me ever closer to not being in the
business of maintaining a bunch of SoC-specific
android-something-2.6.# trees, which seriously is not a business I
particularly want to be in.

Brian
