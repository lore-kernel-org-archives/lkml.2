Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0KSPof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:44:35 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55805 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752004Ab0KSPoe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:44:34 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 10:44:33 EST
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com>
Date: Fri, 19 Nov 2010 10:38:10 -0500
Message-ID: <AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

Thank you for your reviews.

On Fri, Nov 19, 2010 at 4:58 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> [...]
> On Wed, Nov 17, 2010 at 01:09:35, Ben Gardiner wrote:
>> [...]
>> Changes since v1:
>>  * set INPUT_POLLDEV default for DA850_EVM machine, but don't select it
>>    unconditionally
>
> I didn't see the v1 posting (wonder why), but why is this
> required? Why cant we depend on this being selected from
> Device Drivers->Input device support in menuconfig?

I'm sorry about that. I checked gmane and the v1 never made it to the
davinci-linux list. I think it was because of my (mis)use of git
send-email. Version 2 made it to the list so I've now found the magic
incantation.

The reason we should at least select INPUT_POLLDEV as a default option
is: when it is not set the gpio-keys instances registered by the
da850-evm board setup routine will fail probe() of the gpio-keys
driver since it will not have polled-input support enabled.

By setting INPUT_POLLDEV default for the da850-evm users will get
functioning pushbuttons and switches with the default config but they
will be able to disable INPUT_POLLDEV or gpio-keys drivers in their
defconfig at their convenience.

> [...]
>
>> @@ -349,6 +421,10 @@ static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
>>       {
>>               I2C_BOARD_INFO("tca6416", 0x20),
>>               .platform_data = &da850_evm_ui_expander_info,
>> +             /*
>> +              * TODO : populate at runtime using
>> +              * .irq = gpio_to_irq(GPIO_TO_PIN(2,7)),
>> +              */
>
> You seem to be adding this in this patch and removing
> in 4/4.

Oops. That's my fault. The internal reviewers also reminded me to
remove these before sending. Sorry for the noise/ I will remove this
block in _this_ patch in the re-spin.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
