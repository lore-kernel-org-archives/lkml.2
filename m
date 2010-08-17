Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0HQSWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:22:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42498 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758230Ab0HQSWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:22:52 -0400
Date: Tue, 17 Aug 2010 19:22:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bobby Crabtree <bobbyc@codeaurora.org>, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
Message-ID: <20100817182250.GB5755@opensource.wolfsonmicro.com>
References: <4C6ACF92.7050506@codeaurora.org> <20100817192806.09744719@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817192806.09744719@lxorguk.ukuu.org.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 07:28:06PM +0100, Alan Cox wrote:
> O> int regulator_set_optimum_voltage(struct regulator *regulator,
> >                 int min_uV, int max_uV);

> Pedantic hat on - how can it be optimum if its a range ? (and an
> adjective but that is really pedantic) ;))

> Surely it's not the optimal value, it's the range at which it works at
> all you are defining (between off, and escaping smoke).

> set_voltage_range() sounds rather more natural to me.

The regulator API always specifies voltages in ranges, picking the
lowest possible voltage from the range.

One reason for this is that it allows us to finesse the mismatches
between the fixed steps that regulators offer and the requirements of
consumers - we don't needlessly fail to set a voltage due to a few
milivolts difference that the consumer doesn't care about.  The other
reason is that it maps very well onto a lot of applications which do
have fairly wide acceptable ranges.  For things like DVFS lowering the
frequency will typically reduce the minimum voltage required by the
device but will not affect the maximum voltage it can tolerate so we
allow the driver to specify the full range it can operate at and then
deliver the maximum power saving we can within the constraints of the
system.
