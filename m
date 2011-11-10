Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649Ab1KJQS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:18:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:63573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935607Ab1KJQS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:18:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,489,1315206000"; 
   d="scan'208";a="73009793"
Subject: Re: iwlagn: memory corruption with WPA enterprise
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: =?UTF-8?Q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111110160703.GA2775@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
	 <20111031160342.GB2225@redhat.com> <20111109155411.GA1669@nomi.cz>
	 <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz>
	 <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz>
	 <20111110160703.GA2775@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 07:24:45 -0800
Message-ID: <1320938685.31823.200.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 08:07 -0800, Stanislaw Gruszka wrote:
> On Thu, Nov 10, 2011 at 01:53:47PM +0100, Tomáš Janoušek wrote:
> > > If "dmesg | grep corrupt" will show "Setting corrupt debug order to 1"
> > > patches are in use. Anyway I need to test the patches locally, to see
> > > if they work as expected, perhaps exception is generated but call-trace
> > > is not printed.
> > 
> > It does say that, yes.
> 
> I tested patches. They generate call-trace and make kernel panic when I
> wrote at random address from user address space. However to make kernel
> panic, we should keep as much as possible free memory, otherwise bad code
> corrupt not-protected data. In other words, when you run memory intensive
> application, corruption may happen on valid data.  So to catch the bug,
> you should just use network, and perhaps stress up cpu i.e: by this bash
> command:
> 
> while true; do : ; done 
> 
> Please also configure CONFIG_DEBUG_SET_MODULE_RONX=y, it protect modules
> text/read-only memory against corruption.
> 
> > > Is this happen only with "Intel Corporation Centrino Advanced-N 6205" or
> > > with some other adapters?
> > 
> > I don't have any other iwlwifi adapters, so I wouldn't know. The people in
> > that Ubuntu bugreport have exactly that card as well, but in another notebook.
> > And they claim it works in newer Ubuntu, but I am running latest kernels with
> > latest uCode, so I'm out of ideas what else could be wrong.
> 
> That's good hint for Intel folks. Would be ideal if any developer could
> reproduce that. I do not have this exact adapter model.
> 
> > > > Perhaps it would be cheaper to just get another card in that case.
> > > > :-)
> > >
> > > That will left issue unresolved :-(
> > 
> > Yeah, but considering how few people report this, I'm starting to feel that it
> > might in fact be a hardware issue.
> 
> It's possible, but I don think so. In my practice, majority of corruption
> problems was caused by software. All true hardware corruptions I meet, was on
> development boards, many months before they went into production.
> 
> > (We've got a lot of Lenovos here, mostly T520 and T420s, most of them running
> > Fedora, and nobody has reported memory corruption problems.
> 
> Are there any others with 6205? If not that would confirm issue is
> related with that model.

We try very hard on 6205 but can not reproduce this issue, I agree with
Stanislaw the memory corruption is most likely a sw problem.
1. please try older kernel, and possible bisect the kernel
2. could you provide your system information (model, CPU, memory,
graphic, ...), also the OS/kernel version and .config file. not sure we
have the similar system available, but I will like to see if there
anything stand out.

Thanks
Wey

> 
> > Perhaps I should try to connect to this WPA Enterprise using Windows and see
> > if anything goes wrong. However, I have no clue as to what shall I do to
> > reproduce the issue in Windows.)
> 
> You may first try some older kernel as Wey suggested, i.e. 2.6.38.
> 



