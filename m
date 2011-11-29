Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1K2Vnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:43:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:43919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1K2Vnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:43:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="81317764"
Date: Tue, 29 Nov 2011 13:43:43 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MCE/Package power limit notification
Message-ID: <20111129214342.GB5412@linux-os.sc.intel.com>
References: <20111123160950.67860131@x220> <987664A83D2D224EAE907B061CE93D53027D89B577@orsmsx505.amr.corp.intel.com> <493994B35A117E4F832F97C4719C4C04022D835792@orsmsx505.amr.corp.intel.com> <20111129222424.498469fe@x220.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129222424.498469fe@x220.fritz.box>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:24:24PM -0800, Udo Steinberg wrote:
> On Mon, 28 Nov 2011 14:50:47 -0800 Yu, Fenghua (YF) wrote:
> 
> YF> I sent out a patch to remove the mcelog info. Could you try it and see if it works for you?
> YF> https://lkml.org/lkml/2011/11/14/239
> YF> 
> YF> Thanks.
> YF> 
> YF> -Fenghua
> 
> Hi Fenghua,
> 
> Thanks for the patch. It works and eliminates the MCE warnings. What exactly
> are the BIOS issues mentioned in the patch description? Is BIOS programming
> some MSRs the wrong way?

Hi, Udo,

Could you please check counters in /sys/devices/system/cpu/cpu#/thermal_throttle
and see which counters report the thermal events?

The thought of the patch is to remove the errors in mcelog and report the errors
in respective counters. Therefore, the events are not reported as scary hardware
issues but are still captured in counters.

I think BIOS/firmware sets up power limit or thermal throttle incorrectly and
triggers events incorrectly. You may try updated BIOS to see if the events go
away.

Thanks.

-Fenghua
