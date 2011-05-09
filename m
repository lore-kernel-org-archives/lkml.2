Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1EISHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:07:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:7595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1EISHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:07:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,341,1301900400"; 
   d="scan'208";a="744595071"
Date: Mon, 9 May 2011 10:55:32 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv3] x86, mrst: share APB timer code with other platforms
Message-ID: <20110509105532.71b78cc3@putvin>
In-Reply-To: <20110508171617.GA2943@pulham.picochip.com>
References: <1302606630-12459-1-git-send-email-jamie@jamieiles.com>
	<20110508171617.GA2943@pulham.picochip.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 May 2011 18:16:17 +0100
Jamie Iles <jamie@jamieiles.com> wrote:

> On Tue, Apr 12, 2011 at 12:10:30PM +0100, Jamie Iles wrote:
> > The APB timers are an IP block from Synopsys (DesignWare APB timers)
> > and are also found in other systems including ARM SoC's.  This patch
> > adds functions for creating clock_event_devices and clocksources
> > from APB timers but does not do the resource allocation.  This is
> > handled in a higher layer to allow the timers to be created from
> > multiple methods such as platform_devices.
> > 
> > Changes since v2:
> > 	- Make eoi() for clock_event_device optional for x86 where
> > eoi is handled in firmware.
> > Changes since v1:
> > 	- Use the correct timer for clocksource on x86
> > 	- Select the correct timer rating for x86
> > 	- Restore freerunning timer behaviour for oneshot event
> > devices
> > 	- Reenable event irq correctly for hotplug
> > 
> > Cc: John Stultz <johnstul@us.ibm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> 
> Ping?
Just to confirm on my side of testing, they are good on Moorestown
platform.
