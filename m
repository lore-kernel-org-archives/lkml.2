Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1JJU7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:59:50 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:54404 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1JJU7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:59:49 -0400
Date: Mon, 10 Oct 2011 14:59:48 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110101455590.5205@utopia.booyaka.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com> <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com> <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com> <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 10 Oct 2011, Munegowda, Keshava wrote:

> Here is the highlights of the change in the design of  USB Host which
> we can do after kernel 3.2 release;
> 
> 1. separate the TLL changes  from UHH
> 2. The TLL is be a new platform driver in ./drivers/mfd
> 3. the TLL platform driver will export apis  for enable/disable clocks
> and settings.
> 3. the UHH drivers uses these APIS of TLL based on the port
> configurations from board files
>                                      you don't need the TLL clocks to
> be on while all the ports are in phy mode.
> 
> please let me know your thoughts about it.

The TLL driver shouldn't be in drivers/mfd, since it's not an MFD device. 
The TLL driver should go somewhere under drivers/usb.

Basically, the existing OMAP USB subsystem MFD driver should create a TLL 
device.  Then the existing Linux driver probing system can associate the 
TLL driver with the TLL device.


- Paul
