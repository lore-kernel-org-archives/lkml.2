Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3AJOXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:23:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43882 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3AJOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:23:00 -0500
Date: Thu, 10 Jan 2013 14:22:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Don Zickus <dzickus@redhat.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
	secondary cpus
Message-ID: <20130110142245.GE19944@n2100.arm.linux.org.uk>
References: <1357783059-13923-1-git-send-email-ccross@android.com> <20130110140215.GP88797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110140215.GP88797@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 09:02:15AM -0500, Don Zickus wrote:
> On Wed, Jan 09, 2013 at 05:57:39PM -0800, Colin Cross wrote:
> > Emulate NMIs on systems where they are not available by using timer
> > interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> > to check that the next cpu is processing hrtimer interrupts by
> > verifying that a counter is increasing.
> > 
> > This patch is useful on systems where the hardlockup detector is not
> > available due to a lack of NMIs, for example most ARM SoCs.
> 
> I have seen other cpus, like Sparc I think, create a 'virtual NMI' by
> reserving an IRQ line as 'special' (can not be masked).  Not sure if that
> is something worth looking at here (or even possible).

No it isn't, because that assumes that things like spin_lock_irqsave()
won't mask that interrupt.  We don't have the facility to do that.
