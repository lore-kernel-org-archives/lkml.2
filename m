Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0HQVDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:03:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57801 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751025Ab0HQVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:03:13 -0400
Date: Tue, 17 Aug 2010 22:03:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bobby Crabtree <bobbyc@codeaurora.org>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
Message-ID: <20100817210312.GD5755@opensource.wolfsonmicro.com>
References: <4C6ACF92.7050506@codeaurora.org> <20100817181557.GA5755@opensource.wolfsonmicro.com> <4C6AE40D.7090206@codeaurora.org> <20100817195008.GC5755@opensource.wolfsonmicro.com> <4C6AF4B4.4060004@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6AF4B4.4060004@codeaurora.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:44:36PM -0700, Bobby Crabtree wrote:

> Only remaining question I have is if the aggregation of
> multiple consumer constraints should be the default (and only)
> behavior. Or should we introduce a new flag to the
> regulator_constraints structure that tells the core to aggregate
> consumer voltages constraints?

I'd say make it the only behaviour - if there is only one consumer it
decays into the same behaviour as we have currently, and since voltage
changes need to be explicitly enabled by the machine constraints it
should not affect any existing machines.

One thing to take account of is an attempt to set a constraint which
can't be accomodated by the other enabled devices, or enable a device
which has constraints outside the currently allowed range.
