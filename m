Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0IEItR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:49:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46546 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752693Ab0IEItQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:49:16 -0400
Date: Sun, 5 Sep 2010 09:49:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH] regulator: 88pm8607 - fix value range checking for
	accessing info->vol_table
Message-ID: <20100905084915.GD24817@opensource.wolfsonmicro.com>
References: <1283613048.2430.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283613048.2430.5.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 11:10:48PM +0800, Axel Lin wrote:
> In choose_voltage(), we use i as array index of info->vol_table.
> The valid value range for i should be 0 .. ARRAY_SIZE(info->vol_table) - 1.
> 
> Take LDO1 as example, ARRAY_SIZE(LDO1_table) is 4, vol_nbits of LDO1 is 2.
> for (i = 0; i < (2 << info->vol_nbits); i++)  is equivalent to
> for (i = 0; i < 8; i++)
> which is wrong.
> 
> The same value range checking also applies for index in pm8607_list_voltage().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@openource.wolfsonmicro.com>
