Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1HPTtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:49:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1HPTth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:49:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: sdharia@codeaurora.org
Cc: Kenneth Heitke <kheitke@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Tue, 16 Aug 2011 21:49 +0200
Message-ID: <4380004.YTvKt3Mlxd@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <4E4AA52E.1070706@codeaurora.org> <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:77w270eBUgiWhhBlP0GaRSBtwVS8lDzW8v/D2PYxP6T
 AfBDNS3avYhfk2hm3H5c0hGOMFnGdUuIsdvbxRdnI/FA7kuJYC
 MWRXlle63cORlD4yA3Hq+k3JZ/EH4GPcapxw8OVlnAh0CMz5/H
 6E7vTA9HbAZ9inEcKNJ9d8DiDbp1uWVR2vAIOmvkirme6EBtoJ
 ouSkGE/KnPtiUeUqFtv1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011 10:44:35 sdharia@codeaurora.org wrote:
> >
> > SLIMbus is a MIPI standard bus primarily used for digital audio devices.
> >   The devices on the bus SLIMbus enumerate themselves by sending an
> > IDENTITY message.  I'll let Sagar clarify further.
> 
> Thanks everyone for taking your time to review the RFC.
> Regarding device discovery:
> Every device sends a "PRESENT" message when it comes up. Every device has
> 48-bit address like Ethernet and spec lets upto 256 devices (each getting
> 8-bit logical address) on one bus.
> The device can report anytime (when it's plugged in, when a dynamic module
> powers it on etc.)
> Typical use case will be to have it board-specific but as Mark
> mentioned,we may have plug-in cards with slimbus devices so we want
> dynamic support as well.

Thanks for the info. The part that I still don't understand is how the
48-bit address and the 8 bit address are chosen. Do you mean that
the 8-bit address identifies the location on the bus and is used
when talking to the device locally while the 48-bit address is globally
unique and different for each individual board?

In that case, we would still not have any way to identify the type
of device, other than using a look-up table of 8-bit addresses to
device names (or numbers).

Or does the 48-bit number actually tell us something about what
device we're talking to, e.g. 24 bit vendor plus 24 bit device
type and revision or such. If that's the case, the number needs
to be the primary key that gets used to identify the driver,
just like we do it in case of USB or PCI devices.

	Arnd
