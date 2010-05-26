Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab0EZTvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:51:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59557 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab0EZTvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:51:14 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BFD6C2B.4070403@athenacr.com>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>
	 <1274834888.4678.66.camel@localhost.localdomain>
	 <4BFC8C77.7020802@athenacr.com> <1274886299.1759.8.camel@work-vm>
	 <4BFD4629.6040602@athenacr.com> <1274891109.1759.27.camel@work-vm>
	 <4BFD6C2B.4070403@athenacr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:49:50 -0700
Message-ID: <1274903390.3383.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 14:44 -0400, Brian Bloniarz wrote:
> On 05/26/2010 12:25 PM, john stultz wrote:
> > Brian: is this something the NTPd folks actually want? Has anyone
> > checked with them before we hand down the solution from high upon on
> > lkml mountain?
> 
> I haven't checked, it's been a while since I dealt with
> this problem. The NTP maintainers definitely complain about the
> quick TSC calibration code like it's a bug:
> (e.g. http://www.mail-archive.com/questions@lists.ntp.org/msg02079.html).
> Anyway I'll reach out before I spend any time investing in
> a solution that they don't want (and you don't like :).
> 
> > Personally I think NTPd should be a little more savvy about how far it
> > trusts the drift file when it starts up. Since I believe its
> > fast-startup mode can quickly estimate the drift well within 100ppm,
> > which is about the maximum variance I've seen from the calibration code.
> 
> The workaround we went with was to remove the drift file on 
> every reboot. But in our experience, even with iburst, converging takes
> a long time. I don't have hard numbers since it's been a long time since
> I investigated the problem, but we defined failure as >1ms offset syncing
> to a server in our LAN, and a cold NTP boot takes 10-20 hours to get
> there.

Ok. If its been awhile, you may find recent kernels (2.6.31+) are much
faster to converge due to adjustments made to the SHIFT_PLL constant.
This was done explicitly to address issues similar to what you describe
above.

thanks
-john

