Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2HJM1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:27:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37119 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2HJM1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:27:53 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120810100547.GG24328@opensource.wolfsonmicro.com>
References: <1344562353.2996.1.camel@phoenix> <20120810100547.GG24328@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 10 Aug 2012 20:27:32 +0800
Message-ID: <CAF+7xWmmuf0bSROpvd+2RW-XFV=_nf6Zu3KC9-hW2rWDwVwncg@mail.gmail.com>
Subject: Re: [PATCH 1/6] regulator: core: Add checking n_voltages if using
 list_voltage() to read voltage regulators
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Aug 10, 2012 at 09:32:33AM +0800, Axel Lin wrote:
>> Use list_voltage() to read single voltage regulators should be only applied to
>> single voltage regulators, thus add checking n_voltages for this case.
>
> We should be failing to register these regulators in the first place, or
> at least complaining extremely loudly about them.

Oh. My original intention is to prevent using list_voltage() to read
voltage regulators for the case "n_voltages > 1" in case of both get_voltage
and get_voltage_sel are not implemented.
