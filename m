Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1DGACx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:02:53 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:18488 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab1DGACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:02:50 -0400
X-Greylist: delayed 9689 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 20:02:48 EDT
X-MDAV-Processed: mail.academy.zt.ua, Thu, 07 Apr 2011 03:02:47 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 07 Apr 2011 03:02:46 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=4-LgrkjG96+Ar3SjMOsKh-dMuLg@mail.gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 <op.vtisojsk3ri7v4@arend-laptop>
	 <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	 <op.vti9ote53ri7v4@arend-laptop>
	 <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
	 <BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
	 <1302123428.20093.6.camel@maggie>
	 <BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com>
	 <1302124112.20093.11.camel@maggie>
	 <BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com>
	 <1302124737.27258.7.camel@dev.znau.edu.ua>
	 <BANLkTi=4-LgrkjG96+Ar3SjMOsKh-dMuLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Apr 2011 03:00:29 +0300
Message-Id: <1302134429.27258.32.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> W dniu 6 kwietnia 2011 23:18 użytkownik George Kashperko
> <george@znau.edu.ua> napisał:
> >> We have 2 windows. I didn't try this, but let's assume they have no
> >> limitations. We can use first window for one driver only, second
> >> driver for second driver only. That gives us 2 drivers simultaneously
> >> working drivers. No driver need to reset core really often (and not
> >> inside interrupt context) so we will switch driver's window to agent
> >> (from core) only at init/reset.
> >>
> >> The question is what amount of driver we will need to support at the same time.
> >>
> >
> > I guess (correct me please, Broadcom guys if I'm wrong) there are two
> > functions two-head w11 pci host and therefore 4 sliding windows, 2 per
> > each function.
> 
> I don't understand you. Can you use more friendly language? functions?
> 2head? w11?
> 

For PCI function description take a look at PCI specs or PCI
configuration space description (e. g.
http://en.wikipedia.org/wiki/PCI_configuration_space)

Sorry for missleading short-ups, w11 - bcm80211 core, under two-head I
mean ssb/axi with two functional cores on same interconnect (like w11
+w11, not a lot of these exists I guess). Also there were some b43+b44
on single PCI ssb host and those where implemented as ssb interconnect
on multifunctional PCI host therefore providing separate access windows
for each function.

Might I mussunderstood something (its late night here at my place) when
you where talking about using coreswitching involved for two drivers
therefore I remembered about those functions. Seems now you were talking
about chipcommon+b43 access sharing same window.

As for core switching requirments for earlier SSB interconnects on PCI
hosts where there were no direct chipcommon access, that one can be
accomplished without spin_lock/mutex for b43 or b44 cores with proper
bus design.

AXI doesn't need spinlocks/mutexes as both chipcommon and pci bridge are
available directly and b43 will be the only one requiring window access.

Have nice day,
George


