Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab0ERTJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:09:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:31697 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602Ab0ERTI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,257,1272870000"; 
   d="scan'208";a="622746407"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Young, Brent" <brent.young@intel.com>
Date: Tue, 18 May 2010 12:08:58 -0700
Subject: RE: Hardware Error Kernel Mini-Summit
Thread-Topic: Hardware Error Kernel Mini-Summit
Thread-Index: Acr2u2YUMjSyUKCaRGOGQy3g1juG3gAARKqA
Message-ID: <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
In-Reply-To: <20100518185305.GA23921@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It makes sense to use the kernel's performance events 
> logging framework when we are logging events about how the 
> system performs.

Perhaps it makes more sense to say that the Linux "performance
events logging framework" has become more generic and is really
now an "event logging framework".

> Furthermore it's NMI safe, offers structured logging, has 
> various streaming, multiplexing and filtering capabilities 
> that come handy for RAS purposes and more.

Those of us present at the mini-summit were not familiar with
all the features available. One area of concern was how to be
sure that something is in fact listening to and logging the
error events.  My understanding is that if there is no process
attached to an event, the kernel will just drop it.  This is
of particular concern because the kernel's first scan of the
machine check banks occurs before there are any processes.
So errors found early in boot (which might be saved fatal
errors from before the boot) might be lost.

-Tony
