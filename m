Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0KXRQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:16:48 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38238 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753487Ab0KXRQr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024793194E@dbde02.ent.ti.com>
References: <cover.1290201713.git.bengardiner@nanometrics.ca>
	<cover.1290540916.git.bengardiner@nanometrics.ca>
	<9e73184bfb5c0a0d47377dd9b0627405dd87ce8a.1290540916.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB593024793194E@dbde02.ent.ti.com>
Date: Wed, 24 Nov 2010 12:16:46 -0500
Message-ID: <AANLkTinunPwAxOvm03dUHz-nCQY+xXVsoGZZihRWzsvf@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] da850-evm: add UI Expander pushbuttons
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Wed, Nov 24, 2010 at 8:16 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> Hi Ben,
>
> I have some minor comments on this patch. You could
> wait for other pending items to get resolved before
> posting a re-spin.

Thank you for your continued interest and input.

> On Wed, Nov 24, 2010 at 01:10:57, Ben Gardiner wrote:
>
>>  arch/arm/mach-davinci/board-da850-evm.c |   98 ++++++++++++++++++++++++++++++-
>>  1 files changed, 97 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
>
>> +static struct gpio_keys_button da850_evm_ui_keys[] = {
>> +     [0 ... DA850_N_UI_PB - 1] = {
>> +             .type                   = EV_KEY,
>> +             .active_low             = 1,
>> +             .wakeup                 = 0,
>> +             .debounce_interval      = DA850_KEYS_DEBOUNCE_MS,
>> +             .code                   = -1, /* assigned at runtime */
>> +             .gpio                   = -1, /* assigned at runtime */
>> +             .desc                   = NULL, /* assigned at runtime */
>> +     },
>> +};
>> +
>> +static struct gpio_keys_platform_data da850_evm_ui_keys_pdata = {
>> +     .buttons = da850_evm_ui_keys,
>> +     .nbuttons = ARRAY_SIZE(da850_evm_ui_keys),
>> +     .rep = 0, /* disable auto-repeat */
>> +     .poll_interval = DA850_GPIO_KEYS_POLL_MS,
>> +};
>> +
>> +static struct platform_device da850_evm_ui_keys_device = {
>> +     .name = "gpio-keys",
>> +     .id = 0,
>> +     .dev = {
>> +             .platform_data = &da850_evm_ui_keys_pdata
>> +     },
>> +};
>
> No need of zero/NULL initialization in structures above
> since they are static.

It my opinion -- please tell me if it is wrong :) -- that explicit
initialization of platform data members is better than implicit
initialization; future developers and browsers of the code can see
that wakeup events are disabled as are auto-repeats.

I also included the .desc = NULL explicitly to indicate that it would
be populated at runtime so that future developers who grep the code
would know to look for a runtime initialization.

The .id = 0 is there since the bb keys get .id = 1.

As I said please tell me if you would still like me to remove this
expliciti initializations -- I would prefer to leave them as-is.

>> @@ -304,15 +388,24 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
>>       gpio_direction_output(sel_b, 1);
>>       gpio_direction_output(sel_c, 1);
>>
>> +     da850_evm_ui_keys_init(gpio);
>> +     ret = platform_device_register(&da850_evm_ui_keys_device);
>> +     if (ret) {
>> +             pr_warning("Could not register UI GPIO expander push-buttons"
>> +                             " device\n");
>
> Line-breaking an error message is not preferred since it becomes
> difficult to grep in code. Looking at this message, you could drop
> " device" altogether.

Interesting point. Thank you, I really apreciate all the knowledge you
are imparting to me throughout this process. I will remove the "
device" string from the error message entirely.

>> +             goto exp_setup_keys_fail;
>> +     }
>> +
>>       ui_card_detected = 1;
>>       pr_info("DA850/OMAP-L138 EVM UI card detected\n");
>>
>>       da850_evm_setup_nor_nand();
>> -
>
> Random white space change?

Oops, yes -- I am relying to heavily on checkpatch.pl to tell me about
my mistakes. I should be reviewing my patches more closely. Thank you
again.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
