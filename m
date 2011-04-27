Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab1D0KPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:15:54 -0400
Received: from ns.penguin.cz ([84.21.108.25]:34567 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab1D0KPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:15:52 -0400
X-Greylist: delayed 1740 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 06:15:52 EDT
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for
 device PM.
From: Stanislav Brabec <utx@penguin.cz>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>,
        myungjoo.ham@gmail.com
In-Reply-To: <BANLkTi=QDjBtY2WypXjYzyAOUGYjf_oRvw@mail.gmail.com>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
	 <20110426210627.GA28033@elf.ucw.cz> <201104262346.58046.rjw@sisk.pl>
	 <201104270032.42046.rjw@sisk.pl>
	 <BANLkTi=QDjBtY2WypXjYzyAOUGYjf_oRvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 11:46:43 +0200
Message-ID: <1303897603.4431.16.camel@oct.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MyungJoo Ham wrote:

> As long as sysdevs are resumed and some devices/subsystems (I2C-PMIC,
> ADC, and RTC in my cases) can be selectively resumed and suspended, it
> is fine.
> Thus, your "alternative" suggestion is perfect with me. Actually, this
> is almost going back to the original hack. =)
> 
> I'll submit next revision with platform_suspend_ops later.

Does kernel have something like "sleepy task" interface, e. g. special
mode that is triggered by some sort of interrupt and instead of going to
perform full resume, it just lets a hook to wake up "manually" needed
devices, perform the "sleepy task" and then tell the system whether full
resume is requested?

It can fit for Zaurus battery charging monitoring - timer interrupt
needs to wake just the SPI bus.

But I can imagine a GPS logger using such interface to save energy -
serial interrupt semi-wakes the system each second, but will not go to
do full resume. It just processes NMEA sentence and buffers the result.
Only if buffer becomes full, it issues full resume and writes data
somewhere.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12                            tel: +49 911 7405384547
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

