Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab0ELXOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:14:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:53065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab0ELXOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,217,1272870000"; 
   d="scan'208";a="566645399"
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
From: reinette chatre <reinette.chatre@intel.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100512143900.GB6793@localhost>
References: <20100512143900.GB6793@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 16:14:32 -0700
Message-ID: <1273706072.2295.67.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nils,

On Wed, 2010-05-12 at 07:39 -0700, Nils Radtke wrote:
> Problem regarding the deauths/reconnects (sometimes combined w/ bad throughput):
> 
>   Tested w/ Linux mypole 2.6.33.3 #21 SMP PREEMPT Tue May 11 11:41:07 CEST 2010 i686 GNU/Linux
>   and iwl recovery patches applied.
> 

Any chance you can try these same tests with latest code
(compat-wireless may be easiest) to help us determine if this is still
an issue?

> RFKILL switch on, wpa_cli stat showed auth.
> 
> First auth: conn failed during https login
> 
> [28018.602587] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)
> [28018.900400] iwlagn 0000:03:00.0: TX Power requested while scanning!
> [28018.900411] iwlagn 0000:03:00.0: Error sending TX power (-11)
> [28018.921465] iwlagn 0000:03:00.0: request scan called when driver not ready.

We could maybe at least figure out what is going on here if the driver
is loaded with some debugging. Please ensure driver is compiled with
debugging (CONFIG_IWLWIFI_DEBUG) and load the module with "modprobe
iwlagn debug=0x43fff". Could you please reproduce under this
environment?

Reinette



