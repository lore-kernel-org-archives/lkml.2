Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1HYMRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:17:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40025 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1HYMRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:17:15 -0400
Date: Thu, 25 Aug 2011 14:17:10 +0200
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825121710.GK3286@htj.dyndns.org>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
 <201108232351.55432.rjw@sisk.pl>
 <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
 <20110823220056.GK3895@n2100.arm.linux.org.uk>
 <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
 <20110823221314.GL3895@n2100.arm.linux.org.uk>
 <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
 <20110825121416.GB8883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825121416.GB8883@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Russell.

On Thu, Aug 25, 2011 at 01:14:16PM +0100, Russell King - ARM Linux wrote:
> was introduced, every other architecture should have been updated for
> that change...  So this call in the ARM signal handling code to
> try_to_freeze() should just be deleted as it should've been done five
> years ago.

I agree.  I don't think it's necessary there, so for now, let's just
delete that call, but get_signal_to_deliver() expects to be called
with IRQ enabled so it would still be a good idea to turn on/off IRQs
explicitly around it.

Thanks.

-- 
tejun
