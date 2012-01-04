Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2ADSm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:42:58 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53231 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2ADSm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:42:57 -0500
Message-ID: <1325702212.3037.102.camel@work-vm>
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598  1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
From: John Stultz <john.stultz@linaro.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: NeilBrown <neilb@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 10:36:52 -0800
In-Reply-To: <4F040B25.1080405@canonical.com>
References: <1599287628.20120103171351@eikelenboom.it>
	 <20120103190754.GA27651@phenom.dumpdata.com>
	 <1325632188.3037.59.camel@work-vm> <20120104113155.27bf6e46@notabene.brown>
	 <1325638380.3037.69.camel@work-vm> <4F040B25.1080405@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010418-1976-0000-0000-0000092819F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 09:17 +0100, Stefan Bader wrote:
> Over night I had still be thinking on this and maybe one important fact I had
> been ignoring. This really has only been observed on paravirt guests on Xen as
> far as I know. And one thing that I should have pointed out is that
> 
> [    0.792634] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    0.792725] rtc_cmos: probe of rtc_cmos failed with error -38
> 
> So first the registration is done and the first line is the last thing printed
> in the registration function. Then, and that line always comes after, the probe,
> which looks like being done asynchronously, detects that the rtc is not
> implemented. I would assume that this causes the rtc to be unregistered again
> and that is probably the point where, under the right circumstances, the worker
> triggered by the initialize alarm is trying to set another alarm. Probably while
> some of the elements of the structure started to be torn down. I need to check
> on that code path, yet. So right now its more a guess.

Hrm. Do you see the same probe error with 3.1 kernels as well?  

Konrad: Is the probe failure a known issue on Xen? Any clues on whats
going on there?

thanks
-john


