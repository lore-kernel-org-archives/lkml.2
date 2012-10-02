Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2JBI2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:28:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56556 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2JBI2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:28:04 -0400
Message-ID: <506AA57B.50807@ti.com>
Date: Tue, 2 Oct 2012 13:57:39 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "Philip, Avinash" <avinashphilip@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <gururaja.hebbar@ti.com>
Subject: Re: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support
 for APWM driver
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com> <1348658863-29428-2-git-send-email-avinashphilip@ti.com> <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de> <506A94C0.1010106@ti.com> <20121002080751.GA16928@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121002080751.GA16928@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2012 1:37 PM, Thierry Reding wrote:
> On Tue, Oct 02, 2012 at 12:46:16PM +0530, Sekhar Nori wrote:
>> Hi Thierry,
>>
>> On 10/2/2012 11:30 AM, Thierry Reding wrote:
>>> On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
>>> [...]
>>>> +#include <linux/platform_data/ti-pwmss.h>
>>> [...]
>>>> +static struct pwmss_platform_data am33xx_data = {
>>>> +	.has_configspace	= true,
>>>> +};
>>>
>>> This structure is defined in a public header. I don't see why it has to,
>>> given that it's only used to associate some data with an of_device_id
>>> entry below. Since AM33xx never had anything but OF support in the
>>> mainline kernel I don't think we should add platform data.
>>
>> Avinash probably introduced platform data because the same PWM IP is
>> used in older DaVinci family SoCs (DA830 and DA850) which are not
>> converted to DT. There are existing boards for those SoCs  (supported in
>> mainline) which could benefit from this driver.
> 
> Okay. If that's the case platform data should be added along with
> support for those SoCs. Ideally, of course, the DaVinci boards would be
> converted to DT first so we wouldn't have to introduce platform data
> just to get rid of it when the conversion does take place. Until now it
> seems like the boards have managed to get by without PWM support so
> maybe they just don't use or need it?

On top of my head, the DA850 EVM uses PWM for LCD backlight control.
Attempts were made in the past to support PWM on this board back when
Bill Gatliff was attempting to get a framework accepted. So, I guess the
boards were waiting for a framework to materialize ;-)

I posted some patches to add basic DT support for DA850 EVM. It will be
a while before the entire board is converted over. Also, platforms like
DA830 have lesser number of users so it will likely not be converted at all.

It is fair to add platform data along with SoC support. Thanks!

Regards,
Sekhar
