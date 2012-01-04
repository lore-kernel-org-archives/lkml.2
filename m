Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2ADSft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:35:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35481 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2ADSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:35:47 -0500
Message-ID: <1325702132.3037.100.camel@work-vm>
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598  1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
From: John Stultz <john.stultz@linaro.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: NeilBrown <neilb@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 10:35:32 -0800
In-Reply-To: <4F04452C.7020209@canonical.com>
References: <1599287628.20120103171351@eikelenboom.it>
	 <20120103190754.GA27651@phenom.dumpdata.com>
	 <1325632188.3037.59.camel@work-vm> <20120104113155.27bf6e46@notabene.brown>
	 <1325638380.3037.69.camel@work-vm> <4F040B25.1080405@canonical.com>
	 <4F04452C.7020209@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010418-2398-0000-0000-0000032A70A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 13:25 +0100, Stefan Bader wrote:
> Which may point to execution of the irq worker (including a schedule_work)
> before the rtc-cmos parts are finished... Would explain why moving the
> initialize call further down does at least narrow the window for it to happen...
> The only thing I do not understand then is why that seems only to happen on Xen
> guests...

Its just likely with Xen SMP guests that the race window is larger. I
suspect similar behavior could be tripped on other slower SMP boxes as
well.

thanks
-john


