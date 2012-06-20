Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2FTUzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:55:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34510 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2FTUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:55:40 -0400
Message-ID: <4FE238C9.3010408@wwwdotorg.org>
Date: Wed, 20 Jun 2012 14:55:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: boot_on regulator constraint vs. regulator-boot-on DT property
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam, Mark,

I've spotted what seems like a slight inconsistency between the
documentation for the boot_on regulator constraint, and the
regulator-boot-on DT property documentation.

include/linux/regulator/machine.h says:

>  * @boot_on: Set if the regulator is enabled when the system is initially
>  *           started.  If the regulator is not enabled by the hardware or
>  *           bootloader then it will be enabled when the constraints are
>  *           applied.

Documentation/devicetree/bindings/regulator/regulator.txt says:

> - regulator-boot-on: bootloader/firmware enabled regulator

... and of_regulator.c sets the boot_on constraint based on this property.

The former quote implies that this is a flag to tell Linux to turn on
the regulator when it's first registered, whereas the latter quote
implies that it's guaranteeing the state that previous SW placed the
regulator into already.

I assume the documentation from machine.h is correct, and I should send
a patch to make regulator.txt match it?

Thanks.
