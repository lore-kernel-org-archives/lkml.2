Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2FLHeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:34:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36180 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2FLHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:34:04 -0400
Message-ID: <4FD6F0E8.5040606@linaro.org>
Date: Tue, 12 Jun 2012 08:34:00 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
In-Reply-To: <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 21:37, Linus Walleij wrote:
> On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones<lee.jones@linaro.org>  wrote:
>
>> As new users are
>> added, it is expected that they will be Device Tree compliant.
>> If this is the case, we will look up their initialisation values
>> by compatible entry, then apply them forthwith.
> (...)
>> +static struct nmk_i2c_controller u8500_i2c = {
>> +       /*
>> +        * slave data setup time, which is
>> +        * 250 ns,100ns,10ns which is 14,6,2
>> +        * respectively for a 48 Mhz
>> +        * i2c clock
>> +        */
>> +       .slsu           = 0xe,
>> +       /* Tx FIFO threshold */
>> +       .tft            = 1,
>> +       /* Rx FIFO threshold */
>> +       .rft            = 8,
>> +       /* std. mode operation */
>> +       .clk_freq       = 100000,
>> +       /* Slave response timeout(ms) */
>> +       .timeout        = 200,
>> +       .sm             = I2C_FREQ_MODE_FAST,
>> +};
>
> So why don't we create proper device tree bindings for the above platform
> data?
>
> For example several driver under
> Documentation/devicetree/bindings/i2c/*
> define the .clk_freq above as "clock-frequency"
>
> samsung-i2c even has this:
> samsung,i2c-sda-delay =<100>;
> samsung,i2c-max-bus-freq =<100000>;
>
> Where i2c-sda-delay corresponds to slsu above.
>
> I suspect .sm can be derived from the frequency so it
> is "FAST" whenever the frequency>  100000.
>
> This looks to me like a way to push the burden of doing the real
> device tree binding for the above to the next user.
> (Which will likely be me, so therefore I care a bit ...)

On the contrary. This will avoid any added Device Tree complexity and 
ensure that no extra vendor specific bindings are required. When a new 
user wishes to use the driver, all they (you) have to do is create a new 
struct with the platform specific information and add the entry to 
nmk_gpio_match[], simples.

I've even added the logic to extract any information you provide via 
nmk_gpio_match[] for use as platform data. This keeps it both out of 
platform code and the Device Tree binary. Everyone's a winner. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
