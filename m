Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1GFBmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:42:15 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56663 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1GFBmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:42:14 -0400
Date: Tue, 5 Jul 2011 19:42:13 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>,
        =?ISO-8859-15?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid resetting
 IP blocks during init
In-Reply-To: <20110704085503.GQ23145@atomide.com>
Message-ID: <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com>
References: <20110703010204.19046.85186.stgit@dusk> <20110703010206.19046.85293.stgit@dusk> <20110704085503.GQ23145@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Aaro

On Mon, 4 Jul 2011, Tony Lindgren wrote:

> Also related is the gptimer12 on secure omaps as reported by Aaro.

This problem is actually worse.  In this case it's not just preventing 
reset; we must prevent the kernel from using the device at all. My 
understanding is also that it's the X-Loader or bootloader -- or more 
broadly, secure mode code -- that actually chooses which devices are 
protected in this way.  In other words, we can't make any automatic 
decisions that are based on knowing that a chip is a high-security chip -- 
it will need to be defined by the board file :-(

For this case, we probably need some board file function to tell the hwmod 
code to disregard a device completely, to tell the kernel to pretend that 
the device does not exist.


- Paul
