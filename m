Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1HCMVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:21:12 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:29567 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab1HCMVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:21:03 -0400
Date: Wed, 3 Aug 2011 14:18:04 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110803121804.GA29034@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-9-git-send-email-manohar.vanga@cern.ch>
 <4E3911E7.10401@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E3911E7.10401@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> I haven't got any hardware old enough to hand to play with how ISA devices get
> bound into the device model.

Neither do I! I studied the code in drivers/base/isa.c to understand how it is
being done. More specifically, take a look at isa_register_driver() and
isa_bus_match() and you will see the similarities with this patch :)

> I was thinking that we may be able to do vme-$bus_id.$device_id, but this
> would require the $device_id to be unique per bus, which isn't an issue on
> buses such as PCI (or I guess USB) where such enumeration is built into the
> spec. With the exception of VME64x, which I guess we should really be
> treating as a special case (I guess most cards in actual use don't follow
> this standard), we are much closer to the ISA bus.

Exactly. This is great for VME64x but unfortunately makes the rest of the
cases a bit constrained.

> I assume that $driver_name-$bus_id.$device_id is roughly in line with how ISA
> would do this (IIRC, ther would only ever be one ISA bus on a board, so the
> bus entry wouldn't be needed, but we clearly need this)?

Yup. (Most of this code was taken from drivers/base/isa.c)

Thanks!

--
/manohar
