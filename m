Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab0ERUoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:44:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48293 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0ERUn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:43:59 -0400
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	 <alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
	 <20100512103422.1d59cc85@feng-i7>
	 <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 18 May 2010 13:43:54 -0700
Message-ID: <1274215434.1699.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 11:15 +0200, Thomas Gleixner wrote:
> 
> 
> There is no particular reason why we need to read it in
> timekeeping_init(). Nothing in the kernel needs the correct wall time
> at that point. So we can safely move the setting of xtime to rtc wall
> clock time to a separate timekeeping_late_init() function.
> 
> John ???

No big objections here. Still would like to keep the amount of time that
the kernel is up without xtime being initialized to a minimum. However
the generic RTC code already have this issue since some of them require
interrupts to be enabled to do a read, so pushing it off into a
_late_init() function is probably just a short term fix until we figure
out how to get the generic RTC code working better with the timekeeping
code.

Does the delayed init required by vrtc cause any trouble with
suspend/resume?

thanks
-john 

