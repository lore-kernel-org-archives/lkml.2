Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab2HKCXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 22:23:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57582 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2HKCXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 22:23:15 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120810122903.GJ24328@opensource.wolfsonmicro.com>
References: <1344562353.2996.1.camel@phoenix> <20120810100547.GG24328@opensource.wolfsonmicro.com>
 <CAF+7xWmmuf0bSROpvd+2RW-XFV=_nf6Zu3KC9-hW2rWDwVwncg@mail.gmail.com> <20120810122903.GJ24328@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 11 Aug 2012 10:22:54 +0800
Message-ID: <CAF+7xWnmoopw1-GEBAFe5Jsats5Zu5Xw0mJKqVX8Jf7QCCcFkg@mail.gmail.com>
Subject: Re: [PATCH 1/6] regulator: core: Add checking n_voltages if using
 list_voltage() to read voltage regulators
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Aug 10, 2012 at 08:27:32PM +0800, Axel Lin wrote:
>> 2012/8/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > We should be failing to register these regulators in the first place, or
>> > at least complaining extremely loudly about them.
>
>> Oh. My original intention is to prevent using list_voltage() to read
>> voltage regulators for the case "n_voltages > 1" in case of both get_voltage
>> and get_voltage_sel are not implemented.
>
> Yes, I see the intention - what I'm saying is that a regulator like that
> makes no sense in the first place.

We do have such case in drivers/regulator/max1586.c

/*
 * The Maxim 1586 controls V3 and V6 voltages, but offers no way of reading back
 * the set up value.
 */
static struct regulator_ops max1586_v3_ops = {
        .set_voltage_sel = max1586_v3_set_voltage_sel,
        .list_voltage = regulator_list_voltage_linear,
        .map_voltage = regulator_map_voltage_linear,
};

static struct regulator_ops max1586_v6_ops = {
        .set_voltage_sel = max1586_v6_set_voltage_sel,
        .list_voltage = regulator_list_voltage_table,
};
