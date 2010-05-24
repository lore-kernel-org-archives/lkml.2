Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0EXSwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:52:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51508 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab0EXSwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:52:04 -0400
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Brian Bloniarz <bmb@athenacr.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
References: <4BF58B59.7080901@athenacr.com AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 11:51:56 -0700
Message-ID: <1274727116.2954.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 11:13 -0700, Dan Magenheimer wrote:
> > From: john stultz [mailto:johnstul@us.ibm.com]
> > 
> > Yea, the relative instability of the tsc calibration at boot is an
> > issue for folks who want very very precise timekeeping immediately
> > after a reboot.
> > 
> > I proposed a solution to this awhile back via a boot option users
> > could use to specify the tsc_khz freq, so it would be consistent from
> > boot to boot. See: https://patchwork.kernel.org/patch/22492/
> > 
> > It didn't really go anywhere due to a lack of public interest.
> > However, if you're interested in playing with it, I can try to revive
> > the patch.
> 
> Another possibility: Optionally trust the stamped rate for the part?
> 
> I understand that on Nehalem this value is available in
> MSR_PLATFORM_INFO[15:8] (google for MSR_PLATFORM_INFO 15 8),
> but I don't know if this MSR is available on older (or AMD)
> processors.

Hmmm. That could be an option for newer cpus that I wouldn't oppose.

While Peter is correct that the stamped value is probably not very
accurate, atleast it would be constant from boot to boot, and NTP's
calculated drift value would be correct. 

We'd need a check to make sure its not way off, since NTP will give up
if its outside 500ppm.  So as long as its close to the calibrated value,
we probably could use it.

thanks
-john


