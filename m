Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab1CJPtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:49:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45843 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1CJPtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <20110310135053.GF22195@opensource.wolfsonmicro.com>
References: <1299764631-2570-1-git-send-email-linus.walleij@stericsson.com>
	<20110310135053.GF22195@opensource.wolfsonmicro.com>
Date: Thu, 10 Mar 2011 16:49:38 +0100
Message-ID: <AANLkTi=EbGiibp4hqBDKpeB4YOLFDRwtiuQyK6b190kZ@mail.gmail.com>
Subject: Re: [PATCH 3/4] regulator: added register initialization for ab8500 regulators
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 2:50 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Mar 10, 2011 at 02:43:51PM +0100, Linus Walleij wrote:
>> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>>
>> The regulators can come up in a number of undefined
>> states, depending on boot path, firmware revisions and
>> things like kexec():ing into a new kernel. Provide a
>> platform initialization vector so that we have a known
>> state when we have booted the kernel.
>
> This should be done using the regulator constraints, there's nothing
> device specific about this.

The commit message is wrong. My bad, BTW, Bengt didn't
write that up. What we're actually passing in from the platform
data is stuff like this (taken from other patch):

+       /*
+        * SysClkReq2Valid1         = SysClkReq2 controlled
+        * SysClkReq3Valid1         = disabled
+        * SysClkReq4Valid1         = SysClkReq4 controlled
+        * SysClkReq5Valid1         = disabled
+        * SysClkReq6Valid1         = SysClkReq6 controlled
+        * SysClkReq7Valid1         = disabled
+        * SysClkReq8Valid1         = disabled
+        */
+       INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID1, 0x2a),

No voltages, currents or anything. The above bits refer to
fields in the regulator register that control real custom stuff.

Mainly it is about hardware signals controlling the regulator
depending on the setting of a number of "SysClkReq" lines,
basically 1-bit pins on the chip.

I will repost with some more clever commit message.

Linus Walleij
