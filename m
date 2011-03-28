Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1C1DKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:10:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:49265 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1C1DKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="619696287"
Date: Mon, 28 Mar 2011 11:12:15 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Feng Tang <feng.tang@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Kp, Jeeja" <jeeja.kp@intel.com>,
        "Fu, Michael" <michael.fu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [Meego-kernel] [PATCH v9 1/2] mrst: export get_gpio_by_name()
 function
Message-ID: <20110328111215.7566cbb9@feng-i7>
In-Reply-To: <4D8FF9E5.8000502@linux.intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
	<1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
	<4D8FF3AE.5060003@linux.intel.com>
	<20110328104719.78740624@feng-i7>
	<4D8FF6BB.6030005@linux.intel.com>
	<20110328110053.5355badb@feng-i7>
	<4D8FF9E5.8000502@linux.intel.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Mon, 28 Mar 2011 11:00:53 +0800
Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 3/27/2011 8:00 PM, Feng Tang wrote:
> > Hi Arjan,
> >
> > On Mon, 28 Mar 2011 10:47:23 +0800
> > Arjan van de Ven<arjan@linux.intel.com>  wrote:
> >
> >> On 3/27/2011 7:47 PM, Feng Tang wrote:
> >>> On Mon, 28 Mar 2011 10:34:22 +0800
> >>> Arjan van de Ven<arjan@linux.intel.com>   wrote:
> >>>
> >>>> On 3/27/2011 7:29 PM, Lu Guanqun wrote:
> >>>>> Export get_gpio_by_name() function and make its name more
> >>>>> focused. We are doing this because currently get_gpio_by_name()
> >>>>> is only used by the devices exported from SFI DEVS table, but
> >>>>> it is also useful for other PCI devices which also use the GPIO
> >>>>> lines, and have their gpio infos in the SFI GPIO table.
> >>>>>
> >>>> I can't say that I like the new name... at all.
> >>>>
> >>>> what's "mid" ?
> >>>> what is wrong with the original name????
> >>>>
> >>> Hi Arjan,
> >>>
> >>> The original get_gpio_by_name() is static and only used in mrst.c
> >>> as it's mrst/mfld specific. So if we call it from a PCI driver,
> >>> that name sounds
> >> get_gpio_by_name() would be a very good generic name for a function
> >> provided by the gpio layer as well.
> > Yes, the "get_gpio_by_name" name itself is very generic, but it's
> > implementation is not in the GPIO core, but inside the mrst.c and
> > bound to Moorestown/Medfield platforms.
> 
> so how about adding it?

Will check gpio core code, thanks,

> 
> >>> like a platform independent general API while it's actually
> >>> mrst/mfld bound. So we would show this dependency from the
> >>> function name.
> >> that makes no sense.
> >> and again, what on earth is a "mid"??????????
> > Sorry for missed it in last email, "mid" stands for Mobile Internet
> > Device, Moorestown/Medfield platform are defined as MID, and this
> > name is already used by some driver files.
> 
> Medfield and MRST are targeting phones. MIDs don't exist... not in
> this decade.
> 
> 
> if it was renamed to sfi_get_gpio_by_name() it might make SOME sense, 
> but even then it's a
> gratuitous rename for a function that's already in the upstream
> kernel.

Thanks for reminding, we'll try to avoid doing so later.

- Feng
