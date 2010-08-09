Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0HIUTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:19:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756735Ab0HIUTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:19:32 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19G6C45WT5GsPTegwtHTNjIEDZ9dqbTNmscP6Dqm5
	Mvp7AVlx1mHRd8
Subject: Re: [BISECTED/2.6.35+] Regression: Machine runs really slowly
 after commit f12a15be
From: Alexey Fisher <bug-track@fisher-privat.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Priit Laes <plaes@plaes.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1281383518.2444.7.camel@localhost.localdomain>
References: <1281186941.23274.5.camel@chi>
	 <1281380498.2444.2.camel@localhost.localdomain>
	 <1281382707.22355.0.camel@mini>
	 <1281383518.2444.7.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 22:19:29 +0200
Message-ID: <1281385169.5065.0.camel@zwerg>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2010-08-09 at 12:51 -0700, john stultz wrote:
> On Mon, 2010-08-09 at 21:38 +0200, Alexey Fisher wrote:
> > cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> > hpet
> > 
> > cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > hpet acpi_pm 
> 
> 
> On Mon, 2010-08-09 at 22:43 +0300, Priit Laes wrote:
> > cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > hpet
> > cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > hpet acpi_pm 
> 
> 
> Ok. Good. Chris Wilson has created the following patch which should
> hopefully resolve this issue. It would be great if you could try booting
> with it to verify that there are no other problems lurking here.
> 
> Thanks again for the great bug reporting!
> 
> thanks
> -john
> 
> 
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Subject: [PATCH] x86/hpet: Use the FSEC_PER_SEC constant for femto-second
>  periods
> 
> The current computation, introduced with f12a15be63, of FSEC_PER_SEC using
> the multiplication of (FSEC_PER_NSEC * NSEC_PER_SEC) is performed only
> with 32bit integers on small machines, resulting in an overflow and a
> *very* short intervals being programmed.  An interrupt storm follows.
> 
> Note that we also have to specify FSEC_PER_SEC as being long long to
> overcome the same limitations.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---


This patch work for me. At least it boot.
Tank you.

