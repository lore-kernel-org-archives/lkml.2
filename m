Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0KWPs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:48:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40460 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0KWPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:48:27 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Nori\, Sekhar" <nsekhar@ti.com>
Cc: Ben Gardiner <bengardiner@nanometrics.ca>,
        "davinci-linux-open-source\@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input\@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan\, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Subject: Re: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
Organization: Deep Root Systems, LLC
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com>
	<AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EB2BE@dbde02.ent.ti.com>
	<AANLkTimRbsmR6xMok8P_wXpQAd1Xykew6_pPhqUWGsEN@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB5930247931247@dbde02.ent.ti.com>
Date: Tue, 23 Nov 2010 07:48:21 -0800
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930247931247@dbde02.ent.ti.com>
	(Sekhar Nori's message of "Tue, 23 Nov 2010 18:08:22 +0530")
Message-ID: <8739qshwhm.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nori, Sekhar" <nsekhar@ti.com> writes:

> Hi Ben,
>
> On Mon, Nov 22, 2010 at 19:20:48, Ben Gardiner wrote:
>> On Mon, Nov 22, 2010 at 6:49 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
>> > On Fri, Nov 19, 2010 at 21:08:10, Ben Gardiner wrote:
>> >> [...]
>> >> By setting INPUT_POLLDEV default for the da850-evm users will get
>> >> functioning pushbuttons and switches with the default config but they
>> >> will be able to disable INPUT_POLLDEV or gpio-keys drivers in their
>> >> defconfig at their convenience.
>> >
>> > I guess we could also just modify the defconfig to switch on
>> > INPUT_POLLDEV? Since only gpio-keys functionality is affected
>> > by not enabling the correct options in kernel, it should be OK.
>>
>> Yes -- only gpio-keys is affected but enabling the option does
>> introduce an additional .o file:
>>
>> drivers/input/Makefile:obj-$(CONFIG_INPUT_POLLDEV)      += input-polldev.o
>>
>> I agree that in its current state a user couls inadvertently disable
>> the gpio-keys support on da850-evm simply by disabling INPUT_POLLDEV
>> -- which is less than Ideal. How about I replace the current changes
>> to arch/arm/mach-davinci/Kconfig with:
>>
>> config KEYBOARD_GPIO
>>         default MACH_DAVINCI_DA850_EVM
>>         select INPUT_POLLDEV
>>
>> So 1) gpio-keys functionality is default for the da850evm and 2)
>> whenever gpio-keys is enabled so is INPUT_POLLDEV.
>
> This looks better than what was posted earlier, but I am not
> sure if platforms should influence driver configuration this
> way.

Agreed.  In general, we should not have machine/platform specific
conditionals in generic Kconfigs.   Generally, this should be handled in
machine/platform specific Kconfigs.

Kevin


> I guess I am just afraid that this makes a precedent for
> many driver config symbols to get replicated in the platform
> Kconfig files.
>
> Lets see if others have an opinion on this.
>
> Thanks,
> Sekhar
