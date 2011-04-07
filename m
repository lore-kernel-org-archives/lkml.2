Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1DGBEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:04:42 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:19494 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab1DGBEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:04:41 -0400
X-MDAV-Processed: mail.academy.zt.ua, Thu, 07 Apr 2011 04:04:37 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 07 Apr 2011 04:04:37 +0300
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
In-Reply-To: <BANLkTinfM0QLFwcKZXfWQ_jNYfBJg_et-Q@mail.gmail.com>
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
	 <1302134429.27258.32.camel@dev.znau.edu.ua>
	 <BANLkTinfM0QLFwcKZXfWQ_jNYfBJg_et-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Apr 2011 04:02:19 +0300
Message-Id: <1302138139.27258.35.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> W dniu 7 kwietnia 2011 02:00 użytkownik George Kashperko
> <george@znau.edu.ua> napisał:
> > For PCI function description take a look at PCI specs or PCI
> > configuration space description (e. g.
> > http://en.wikipedia.org/wiki/PCI_configuration_space)
> >
> > Sorry for missleading short-ups, w11 - bcm80211 core, under two-head I
> > mean ssb/axi with two functional cores on same interconnect (like w11
> > +w11, not a lot of these exists I guess). Also there were some b43+b44
> > on single PCI ssb host and those where implemented as ssb interconnect
> > on multifunctional PCI host therefore providing separate access windows
> > for each function.
> >
> > Might I mussunderstood something (its late night here at my place) when
> > you where talking about using coreswitching involved for two drivers
> > therefore I remembered about those functions. Seems now you were talking
> > about chipcommon+b43 access sharing same window.
> >
> > As for core switching requirments for earlier SSB interconnects on PCI
> > hosts where there were no direct chipcommon access, that one can be
> > accomplished without spin_lock/mutex for b43 or b44 cores with proper
> > bus design.
> >
> > AXI doesn't need spinlocks/mutexes as both chipcommon and pci bridge are
> > available directly and b43 will be the only one requiring window access.
> 
> Ahh, so while talking about 4 windows, I guess you counted fixes
> windows as well. That would be right, matching my knowledge.
Nop, I mean sliding windows only.

> 
> When asking question about amount of cores we may want to use
> simultaneously I didn't think about ChipCommon or PCIe. The real
> problem would be to support for example two 802.11 cores and one
> ethernet core at the same time. That gives us 3 cores while we have
> only 2 sliding windows. But I would not care for that too much for
> now.
That will give us 3 PCI functions, each with own sliding windows.

> 
> For the rest (PCI function) I have to sleep before reading specs ;)
> 

Have nice day,
George


