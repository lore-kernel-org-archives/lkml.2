Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3AIKso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:48:44 -0500
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:58372 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755762Ab3AIKsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:48:42 -0500
Message-ID: <50ED4932.50907@overkiz.com>
Date: Wed, 09 Jan 2013 11:40:50 +0100
From: Boris BREZILLON <linux-arm@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v5] pwm: atmel: add Timer Counter Block PWM driver
References: <1357659402-4574-1-git-send-email-linux-arm@overkiz.com> <20130109074630.GB12782@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130109074630.GB12782@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5274278115340891158
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrgedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrgedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2013 08:46, Thierry Reding wrote:
> On Tue, Jan 08, 2013 at 04:36:42PM +0100, Boris BREZILLON wrote:
>> Hi,
>>
>> This patch adds a PWM driver based on Atmel Timer Counter Block.
>> Timer Counter Block is used in Waveform generator mode.
>>
>> A Timer Counter Block provides up to 6 PWM devices grouped by 2:
>> * group 0 = PWM 0 and 1
>> * group 1 = PWM 2 and 3
>> * group 2 = PMW 4 and 5
>>
>> PWM devices in a given group must be configured with the same
>> period value.
>> If a PWM device in a group tries to change the period value and
>> the other device is already configured with a different value an
>> error will be returned.
>>
>> This driver requires device tree support.
>> The Timer Counter Block number used to create a PWM chip is
>> given by tc-block field in an "atmel,tcb-pwm" compatible node.
>>
>> This patch was tested on kizbox board (at91sam9g20 SoC) with 
>> pwm-leds.
>>
>> Regards,
>>
>> Boris
>>
>> Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
>> ---
>> Changes since v1:
>> 	- Fix device tree binding Documentation
>> 	- Fix Kconfig issues (missing OF dependency, 
>> 				deprecated HAVE_PWM select, ...)
>> 	- Fix various coding style issues.
>> 	- Cleanup code and add some comments.
>>
>> Changes since v2:
>> 	- Replace kzalloc/kfree with managed versions
>> 	  (devm_kzalloc/devm_kfree).
>> 	- Add one cell to device tree binding to support polarity
>> 	  flag.
>> 	- Replace min computation (2 div -> 1 mul + 1 div).
>>
>> Changes since v3:
>> 	- Fix device tree binding Documentation
>> 	- Fix Kconfig description
>> 	- Fix coding style issues (function parameters alignment)
>> 	- Replace 1000000000 value with NSEC_PER_SEC macro
>> 	- Get rid of newcmr variable in enable/disable functions
>> 	- Remove unneeded devm_kfree
>> 	- Add missing atmel_tc_free
>>
>> Changes since v4:
>> 	- Add missing comments
>> 	- Fix coding style issues (multi-line error string)
>> 	- Fix wrong MODULE_DEVICE_TABLE setting
>> 	- Remove unneeded MODULE_ALIAS declaration
>>
>>  .../devicetree/bindings/pwm/atmel-tcb-pwm.txt      |   18 +
>>  drivers/pwm/Kconfig                                |   12 +
>>  drivers/pwm/Makefile                               |    1 +
>>  drivers/pwm/pwm-atmel-tcb.c                        |  445 ++++++++++++++++++++
>>  4 files changed, 476 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
>>  create mode 100644 drivers/pwm/pwm-atmel-tcb.c
> 
> Applied with minor changes to the commit message, thanks.
> 
> Thierry
> 

Thanks
