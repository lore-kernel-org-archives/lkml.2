Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab1DZVQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:16:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39071 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab1DZVPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110426161516.GC11848@opensource.wolfsonmicro.com>
References: <BANLkTi=dCHXEtv+=+sRaDp_Pt3zQy5o7ug@mail.gmail.com>
	<20110426083350.GA20595@sirena.org.uk>
	<BANLkTimmpx5ZThXj705Yn_wRQ6bF7VzwPw@mail.gmail.com>
	<20110426161516.GC11848@opensource.wolfsonmicro.com>
Date: Tue, 26 Apr 2011 16:15:23 -0500
Message-ID: <BANLkTi=KxNRktf3SOzQKK-stu6i+g8n2EA@mail.gmail.com>
Subject: Re: Expose regulator:set_consumer_device_supply()?
From: Bill Gatliff <bgat@billgatliff.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark:

On Tue, Apr 26, 2011 at 11:15 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
> No.  As I said in the text you've quoted above you can also specify the
> device mapping using the dev_name() of the device.

Aah!  I see it now--- the regulator_consumer_supply structure will
take either the consumer's struct device pointer, or the device name
of the consumer's struct device.  The device name can easily be
predicted (controlled, in fact) before the consumer itself is
registered; in the case of i2c devices, it's the bus-id, i.e.
"0-0038".

Now it all fits together for me.  Thanks for your patience!

> It means you get reams of code in drivers conditionally using the
> regulator API, all of which adds needless complexity all over the tree
> as people invariably make everything conditional on the regulator not
> being there when they shouldn't.  This then means you also end up with
> no meaningful error handling, all errors just get silently eaten.

Now I think I see your point: better to have drivers check the result
of regulator_get() themselves, rather than test a pointer coming in
with the platform data.  And since regulators are often registered as
platform devices themselves, there is no way to get a valid result
from regulator_get() in early-init board code anyway.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
