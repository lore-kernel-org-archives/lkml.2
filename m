Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0LPR1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:27:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab0LPR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:27:43 -0500
MIME-Version: 1.0
In-Reply-To: <1292519639-21859-4-git-send-email-w.sang@pengutronix.de>
References: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de> <1292519639-21859-4-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 16 Dec 2010 10:27:22 -0700
X-Google-Sender-Auth: elgFKRwPdKP-R1G1sonD_lRpSU4
Message-ID: <AANLkTikP9CiUXda0ENwNKfviAE6oDVqXwDUKgj8zvpGr@mail.gmail.com>
Subject: Re: [PATCH 3/3] spi: mpc512x_psc_spi: move probe-routine to __init
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:13 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Since of_probe_platform_driver(), this SoC-device can be moved from
> __devinit to __init because it is not hotpluggable.
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

I really wouldn't bother.  You're counting pennies when the kernel
uses upwards of 4 megabytes for .text alone, and I don't like fiddling
with the driver model the way platform_bus_probe() does.

g.
