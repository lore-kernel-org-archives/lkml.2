Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0EQSpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:45:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab0EQSpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:45:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=niwZ9dL5MP687UNIh+QPeQJE5I7MRfo9RzAMFvWsAIJIYQtQQ5IVut2V9elx/PbO3
	1NnLmusVokToKo7UThg7A==
MIME-Version: 1.0
In-Reply-To: <20100517183904.GA14047@gandalf>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
	 <1274115885.4418.59.camel@mulgrave.site>
	 <20100517174647.GA11512@gandalf>
	 <1274119179.4418.68.camel@mulgrave.site>
	 <20100517181252.GA14260@gandalf>
	 <AANLkTikueXPEWEHQt-Fl3Xvb3EB4ntsBlJUjjtmpinGK@mail.gmail.com>
	 <20100517183904.GA14047@gandalf>
Date: Mon, 17 May 2010 11:45:32 -0700
Message-ID: <AANLkTillcFg_y-GeXJNBuIYiGvht-NBZPxwdb71qDui0@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: me@felipebalbi.com
Cc: James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 11:39 AM, Felipe Balbi <me@felipebalbi.com> wrote:
> Hi,
>
> On Mon, May 17, 2010 at 11:26:59AM -0700, Brian Swetland wrote:
>> We (Google) would like to allow completely open app distribution with
>> minimal hurdles, and avoid the walled garden approach.  Toward this
>> goal we're not even requiring the use of a central app store for
>> distribution.
>
> I understand that, but still we should be telling developers what
> they're doing wrong so that they can improve themselves as professionals
> and still make the final device better.

I agree.  Which is why we develop tools to help developers understand
what their apps are doing.

>> For a large majority of apps, running in the background while the
>> device is asleep (screen off) is not essential, they don't request the
>> "keep device awake" permission, never hold a wakelock, etc.  Those
>> that do need to do this have the permission, may hold suspend
>> blockers, and are accounted for.
>
> but can anyone write an app that holds a suspend_blocker ?? If so, then
> your goal is already broken, right ? I mean, if anyone can keep a
> suspend_blocker held forever, you'll never ever sleep, right ? While
> with runtime, if you keep the keypad open, only the keypad and the paths
> directly related to it (probably the i2c controller and the power domain
> where the i2c controller sits) will be kept alive, no ?

No, you'll never suspend, which is different from never going to the
lowest CPU power state.  On shipping Android devices we aggressively
completely power down the CPU in idle whenever we can (based on
latency requirements generally).  We power off peripherals whenever
they're not in use.

This is why I've stated previously that I don't think runtime PM and
opportunistic suspend are competitive features.  Everyone who cares
about minimizing power should want runtime pm or at least similar
functionality (our drivers have always powered down peripherals when
not in use, even while the device is open, etc, prior to the existence
of runtime PM).

If your environment is such that going to full suspend will not gain
you anything, then don't use opportunistic suspend.  We find that
there are savings to be had with this model in Android which is why we
use it.  If you are going to use opportunistic suspend,
suspend_blockers provide useful functionality.

Brian
