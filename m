Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2CALQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:16:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:34003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab2CALQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:16:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131591834"
Date: Thu, 1 Mar 2012 12:23:29 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Message-ID: <20120301112329.GI9008@sortiz-mobl>
References: <y>
 <1330005504-25321-3-git-send-email-prakash.pm@ti.com>
 <20120227142638.GN27687@sortiz-mobl>
 <A73F36158E33644199EB82C5EC81C7BC3176D103@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3176D103@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prakash,

On Tue, Feb 28, 2012 at 05:44:39AM +0000, Manjunathappa, Prakash wrote:
> Hi Samuel,
> 
> On Mon, Feb 27, 2012 at 19:56:38, Samuel Ortiz wrote:
> [snip]
> > So it seems you're passing a platform devices array through your mfd aemif
> > platform data pointer. And from what I can see, it's mostly a 1 entry array
> > (for the NAND case) or a 2 entries array (for the NAND and NOR case).
> > In that case, adding an MFD driver in the middle brings basically nothing but
> > confusion and overhead (and 200+ lines of code).
> > So unless someone explains to me how this is doing any good to the kernel in
> > general, I'm not going to take this patchset.
> > 
> > Cheers,
> > Samuel.
> >
> 
> In this way we trying to isolate future modification of aemif driver not to depict
> as platform code change, the need for this is based on discussion in below thread
> http://davinci-linux-open-source.1494791.n2.nabble.com/PATCH-arm-davinci-configure-davinci-aemif-chipselects-through-OF-tt7059739.html#none
> 
I fail to see how you're going to achieve that with adding an MFD platform
device registration in the middle.


> Earlier also concern was expressed to move aemif driver out of arch/arm to drivers folder.
> Here is the link for the same: http://lists.infradead.org/pipermail/linux-mtd/2011-August/037308.html
> Since aemif driver supports NAND/NOR devices, we feel MFD is the place holder.
I would disagree with that. And it certainly makes sense to move many drivers
out of arch/arm into a more appropriate place but I'd like to keep mfd as
something else than yet another misc.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
