Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0EMXss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:48:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0EMXsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:48:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gZ/oY9dZZdwrnXAmiqJcaspT2qR1CBdr8F9b6vtyBB0RgCmiMb3MzZbBgNvuRNWt/
	bbMPXamVc48b5tspHKnnQ==
MIME-Version: 1.0
In-Reply-To: <20100513233608.GA1582@sirena.org.uk>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <20100513214653.GA21120@suse.de>
	 <20100513222748.GA3240@opensource.wolfsonmicro.com>
	 <201005140046.33508.rjw@sisk.pl> <20100513233608.GA1582@sirena.org.uk>
Date: Thu, 13 May 2010 16:48:40 -0700
Message-ID: <r2qa55d774e1005131648i1702d3b2ob6bc823e4a4a113c@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Daniel Walker <dwalker@fifo99.com>, Matthew Garrett <mjg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, "Arve Hj?nnev?g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       "Beno?t Cousson" <b-cousson@ti.com>, linux-omap@vger.kernel.org,
       Vitaly Wool <vitalywool@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 4:36 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
>> I'm not a big fan of suspend blockers myself, but let's face it, _currently_
>> there's no alternative and we need to stop the trend, the sooner the better.
>
> I don't think this is a major part of the trend - like I say, the fact
> that people have been working with an old kernel version is generally
> a much more substantial issue than the wakelocks in the code I've seen.

Current published trees are based on .32 (used for the coming-soon
froyo release that's been in late QA for a while now) and forward
development is moving to .34 post final (or in the case of tegra2,
tracking .34-rc series as it happens).  We've been actively snapping
up to track mainline since we started doing this around 2.6.16.  We'd
*love* to be able to get more stuff sanely upstream instead of
maintaining branches and rebasing every other mainline release or so.

> The issue was that when I originally noticed the patch series was being
> considered for mainline again was that one effect of using it in a
> mobile phone with the standard Linux embedded audio subsystem would be
> to break use cases such as audio on voice calls, which isn't really
> desirable, and that there was no roadmap for how to fix that or any
> other subsystems with similar issues.  This didn't seem like it would
> have been a good situation given that the major user is expected to be
> Android, which is mainly for mobile phones.

I'd love to have a separate discussion on using standard linux
embedded audio for mobile devices -- one of my goals for 2010 is to
try to migrate from our "one off" approach on MSM to making use of
ALSA and standard interfaces.  I have a lot of questions about handing
encoded data (mp3/aac/etc) that will be processed by the DSP, how to
approach routing control, and how to best interact with the
user/kernel interface, etc.

Brian
