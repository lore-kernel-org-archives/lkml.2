Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2DXMc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:32:59 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:7487 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab2DXMc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:32:58 -0400
Date: Tue, 24 Apr 2012 14:32:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol 
 mangling
Message-ID: <20120424143241.0d66fd2e@endymion.delvare>
In-Reply-To: <4F967089.3050004@nvidia.com>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
	<1335251976-31925-3-git-send-email-ldewangan@nvidia.com>
	<20120424105557.7ac07232@endymion.delvare>
	<4F967089.3050004@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman, Mark,

On Tue, 24 Apr 2012 14:51:13 +0530, Laxman Dewangan wrote:
> The primary use-case here is scatter-gather of multiple I2C messages; 
> the first message will contain the START and perhaps some transfers, 
> then subsequent messages will continue with more data transfers. This 
> removes the need to put all the data transfers into a single message, 
> and hence avoids some copying of commands/data.
> 
> Mark Brown says this is important for regmap. This feature is implement 
> gather support for I2C transfers - the resulting I2C transfer is 
> entirely normal but this ends up being implemented by the controller 
> doing two transfers back to back with no start on the second transfer. 
> To the outside world it looks like a perfectly normal transfer. This 
> behaviour can be emulated by allocating a buffer and coalescing the data 
> into that buffer before sending it to the hardware but this introduces 
> an avoidable and sometimes noticeable overhead.

Please keep in mind that support for I2C_M_NOSTART at the bus driver
level is optional. This means that device drivers are encouraged to not
rely on it unconditionally. Originally the flag was meant to workaround
bogus hardware (the infamous Matrox Maven if memory serves) which
changed the transfer direction without a repeated start in the middle
(which is not allowed by the I2C specification.) It wasn't meant to be
implemented and used widely (as written in
Documentation/i2c/i2c-protocol), which is why it is one of the
I2C_FUNC_PROTOCOL_MANGLING features rather than having its own I2C
functionality flag.

If you want to do scatter-gather for I2C messages, I understand the
benefit and I have no objection, and I agree that I2C_M_NOSTART lets
you do that, but then:
* We should allocate a new functionality flag for it.
* We should update the documentation to reflect the two use cases.

Thanks,
-- 
Jean Delvare
