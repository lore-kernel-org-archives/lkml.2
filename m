Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0KVNu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:50:57 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:37019 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754646Ab0KVNuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:50:54 -0500
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59302477EB2BE@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com>
	<AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EB2BE@dbde02.ent.ti.com>
Date: Mon, 22 Nov 2010 08:50:48 -0500
Message-ID: <AANLkTimRbsmR6xMok8P_wXpQAd1Xykew6_pPhqUWGsEN@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 6:49 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> On Fri, Nov 19, 2010 at 21:08:10, Ben Gardiner wrote:
>> [...]
>> By setting INPUT_POLLDEV default for the da850-evm users will get
>> functioning pushbuttons and switches with the default config but they
>> will be able to disable INPUT_POLLDEV or gpio-keys drivers in their
>> defconfig at their convenience.
>
> I guess we could also just modify the defconfig to switch on
> INPUT_POLLDEV? Since only gpio-keys functionality is affected
> by not enabling the correct options in kernel, it should be OK.

Yes -- only gpio-keys is affected but enabling the option does
introduce an additional .o file:

drivers/input/Makefile:obj-$(CONFIG_INPUT_POLLDEV)      += input-polldev.o

I agree that in its current state a user couls inadvertently disable
the gpio-keys support on da850-evm simply by disabling INPUT_POLLDEV
-- which is less than Ideal. How about I replace the current changes
to arch/arm/mach-davinci/Kconfig with:

config KEYBOARD_GPIO
        default MACH_DAVINCI_DA850_EVM
        select INPUT_POLLDEV

So 1) gpio-keys functionality is default for the da850evm and 2)
whenever gpio-keys is enabled so is INPUT_POLLDEV.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
