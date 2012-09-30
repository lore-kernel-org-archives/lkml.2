Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2I3NoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 09:44:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:37729 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2I3NoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 09:44:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,513,1344236400"; 
   d="scan'208";a="198922710"
Date: Sun, 30 Sep 2012 21:37:43 +0800
From: Feng Tang <feng.tang@intel.com>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: hot CPU with 3.6.0-rc7+ and intel graphic
Message-ID: <20120930213743.69e13db1@feng-i7>
In-Reply-To: <5066AE4B.9090000@gmx.de>
References: <5066AD45.70107@gmx.de>
	<5066AE4B.9090000@gmx.de>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toralf,

On Sat, 29 Sep 2012 10:16:11 +0200
Toralf Förster <toralf.foerster@gmx.de> wrote:

> 
> Hello,
> 
> I'm observed hot CPUs at my ThinkPad T420 (i5-2540M CPU) w/ integrated
> intel graphic with current git
> Powertop-2.1 shows that the GPU is always at 100%.

Where can we get a powertop-2.1? I searched google and found 
git clone git://git.kernel.org/pub/scm/status/powertop/powertop.git
is null now.

> 
> .config is attached

Really weird, my commit only change the lpc_ich.c which affects the TCO_WDT
driver. but from your .config file, neither CONFIG_LPC_ICH nor the
 CONFIG_ITCO_WDT is enabled, which means the commit should not affect
your kernel, could you double check the .config file?

Thanks,
Feng
> 
> 
> I bisected this to
> 
> 
> commit a0e35322910555e20e9eced3f050a76c7b3a1f92
> Author: Feng Tang <feng.tang@intel.com>
> Date:   Thu Aug 16 15:50:10 2012 +0800
> 
>     mfd: lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver
> 
> 
> 
> 
> 
