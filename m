Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2FRFTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:19:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49744 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2FRFTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:19:33 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120617200342.GO4267@opensource.wolfsonmicro.com>
References: <1339137332.16616.0.camel@phoenix> <20120617200342.GO4267@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 18 Jun 2012 13:19:12 +0800
Message-ID: <CAF+7xWnS7+hxgoVbxYghi3Zj007U4tAsNZ6XnwkWEWdyK12+uA@mail.gmail.com>
Subject: Re: [PATCH] regulator: tps62360: Simplify tps62360_set_voltage_time_sel
 implementation
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/18 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Jun 08, 2012 at 02:35:32PM +0800, Axel Lin wrote:
>> For linear mappings, we can use below equation to get the voltage difference
>> between new_selector and old_selector:
>
> Applied, thanks.  There's a new framework feature that Yadwinder Singh
> has contributed which should allow this to be moved to the regulator
> desc.

In this case, tps->change_uv_per_us is is calculated by :
tps->change_uv_per_us = DIV_ROUND_UP(32000, BIT(ramp_ctrl));

Which means tps->change_uv_per_us may be not alignment to mV.

This make me think if we should change the unit of ramp_delay
to uV/uS rather than mV/uS. So we can avoid truncate issue.

Regards,
Axel
