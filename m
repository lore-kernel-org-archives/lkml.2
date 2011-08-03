Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1HCJQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:16:32 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:56434 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1HCJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:16:27 -0400
Message-ID: <4E3911E7.10401@ge.com>
Date: Wed, 03 Aug 2011 10:16:23 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: vme: make match() driver specific to improve
 non-VME64x support
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-9-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1312194053-32310-9-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2011 09:13:15.0243 (UTC) FILETIME=[93835BB0:01CC51BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 11:20, Manohar Vanga wrote:
> For jumper based boards (non VME64x), there is no mechanism
> for detecting the card that is plugged into a specific slot. This
> leads to issues in non-autodiscovery crates/cards when a card is
> plugged into a slot that is "claimed" by a different driver. In
> reality, there is no problem, but the driver rejects such a
> configuration due to its dependence on the concept of slots.
> 
> This patch makes the concept of slots less critical and pushes the
> driver match() to individual drivers (similar to what happens in the
> ISA bus in driver/base/isa.c). This allows drivers to register the
> number of devices that they expect without any restrictions. Devices
> in this new model are now formatted as $driver_name-$bus_id.$device_id
> (as compared to the earlier vme-$bus_id.$slot_number).
> 

I haven't got any hardware old enough to hand to play with how ISA devices get
bound into the device model. I was thinking that we may be able to do
vme-$bus_id.$device_id, but this would require the $device_id to be unique per
bus, which isn't an issue on buses such as PCI (or I guess USB) where such
enumeration is built into the spec. With the exception of VME64x, which I
guess we should really be treating as a special case (I guess most cards in
actual use don't follow this standard), we are much closer to the ISA bus. I
assume that $driver_name-$bus_id.$device_id is roughly in line with how ISA
would do this (IIRC, ther would only ever be one ISA bus on a board, so the
bus entry wouldn't be needed, but we clearly need this)?

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
