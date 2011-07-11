Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1GKDsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:48:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56690 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757003Ab1GKDsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:48:50 -0400
Date: Mon, 11 Jul 2011 12:48:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps65910: Fix array access out of bounds bug
Message-ID: <20110711034840.GA4532@opensource.wolfsonmicro.com>
References: <1310349463.2316.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310349463.2316.4.camel@phoenix>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 09:57:43AM +0800, Axel Lin wrote:
> For tps65910, the number of regulator is 13. ( ARRAY_SIZE(tps65910_regs) is 13)
> For tps65911, the number of regulator is 12. ( ARRAY_SIZE(tps65911_regs) is 12)
> If we are using this driver for tps65911,
> we hit array access out of bounds bug in tps65910_probe() because
> current implementation always assume the number of regulator is 13 and
> thus it will access tps65911_regs[12].
> 
> Fix it by setting correct num_regulators for both chips in tps65910_probe(),
> and allocated neccessay memory accordingly.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This patch would be much less invasive if you didn't change to
allocating everything dynamically - you could fix the out of bounds
issues by just limiting the number of times we go round the array.
