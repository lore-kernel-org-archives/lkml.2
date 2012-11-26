Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2KZQmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:42:07 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53368 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2KZQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/i2c: support more interrupt specifiers
To: Bongkyu Kim <bongkyu.kim@lge.com>, Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <50B2F9FF.9070308@lge.com>
References: <1353488322-14764-1-git-send-email-bongkyu.kim@lge.com> <50ACD9F2.40207@gmail.com> <50B2F9FF.9070308@lge.com>
Date: Mon, 26 Nov 2012 14:08:28 +0000
Message-Id: <20121126140828.555CF3E196F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012 14:11:27 +0900, Bongkyu Kim <bongkyu.kim@lge.com> wrote:
> On 11/21/2012 10:41 PM, Rob Herring wrote:
> > On 11/21/2012 02:58 AM, Bongkyu Kim wrote:
> >> This patch supports more interrupt specifiers for i2c client.
> > 
> > Why?
> > 
> 
> If we are registering a device has 2 interrupts like the below,
> 	i2c@f9968000 {
> 		lsm330_acc@1D {
> 			compatible = "ST,lsm330_acc",
> 			/* #interrupt-cells = <2> */
> 			interrupts = <73 0x2 65 0x2>,
> 		};
> 	};
> 
> we can't use second irq(65) in a driver because of mapping first
> interrupt only.
> If second irq(65) is mapped, we can use by gpio_to_irq() function at a
> driver.
> So, I think that all interrupt specifiers should be parsed and mapped
> if DT's interrupts property is allowed several interrupt specifiers.

This doesn't look like a very good idea. If more than one interrupt is
provided, then each should be entirely parsed in the driver's .probe() or
in of_i2c_register_devices(), not split across the two. Using
gpio_to_irq() to fetch an irq number that was already calculated and
then thrown away is a bizarre back way of going about it. Plus it is
error-probe because nothing will check that the gpio and interrupts
properties agree.

Either the driver should do all the parsing of 2nd and subsequent irqs,
or the i2c subsystem should be extended to support multiple irq
resources.

g.
