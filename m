Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1AJOaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:30:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:8512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1AJOaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:30:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,301,1291622400"; 
   d="scan'208";a="591497122"
Date: Mon, 10 Jan 2011 14:05:38 +0000
From: Alan Cox <alan@linux.intel.com>
To: "Gorby, Russ" <russ.gorby@intel.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "segoon@openwall.com" <segoon@openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ahmed, Suhail" <suhail.ahmed@intel.com>
Subject: Re: [PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on
 platform type
Message-ID: <20110110140538.2d584937@bob.linux.org.uk>
In-Reply-To: <4C5E6457CD7911469A07260381288C28CB7E0263@orsmsx502.amr.corp.intel.com>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
	<1294272313-15899-5-git-send-email-russ.gorby@intel.com>
	<20110106002716.06a396c7@bob.linux.org.uk>
	<4C5E6457CD7911469A07260381288C28CB7E0263@orsmsx502.amr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use_dma is used so the protocol driver matches the expectations
> (capabilities) of the controller driver it attaches to. In the
> general case I would think it could support several different
> controller drivers that might have differing capabilities. Currently
> the driver does assume the value of use_dma is constant for a
> platform so putting this indication in the platform data would
> suffice (for now) but to me, this is not really a platform attribute.
> Is there a better way to handle this is?

The driver should know nothing about the plumbing itself. So the
platform data should deal with this and pass it in generic terms.

In the Intel MID case arch/x86/platform/mrst/ should know about whether
DMA can be used and what mode the SFI controller should be in. The bits
that are in ifx6x60.c should be as architecture neutral as possible.

Alan
