Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1AGTzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:55:52 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:34640 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753775Ab1AGTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:55:51 -0500
Message-ID: <4D276FB8.7030309@armadeus.com>
Date: Fri, 07 Jan 2011 20:55:36 +0100
From: Fabien Marteau <fabien.marteau@armadeus.com>
Reply-To: fabien.marteau@armadeus.com
Organization: ARMadeus Systems
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Trilok Soni <tsoni@codeaurora.org>, Scott Moreau <oreaus@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (third version)
References: <4D22ECB6.6090800@armadeus.com> <4D22FE0F.7010206@codeaurora.org> <4D276CAD.5090604@armadeus.com> <20110107195000.GD28875@core.coreip.homeip.net>
In-Reply-To: <20110107195000.GD28875@core.coreip.homeip.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8051873184284696987
X-Ovh-Remote: 82.232.255.99 (arc68-6-82-232-255-99.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 20:50, Dmitry Torokhov wrote:
> On Fri, Jan 07, 2011 at 08:42:37PM +0100, Fabien Marteau wrote:
>> On 04/01/2011 12:01, Trilok Soni wrote:
>>> Hi Fabien,
>>>
>>> On 1/4/2011 3:17 PM, Fabien Marteau wrote:
>>>> +
>>>> +static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
>>>> +{
>>>> +	struct as5011_platform_data *plat_dat = dev_id;
>>>> +
>>>> +	mutex_lock(&plat_dat->update_lock);
>>>> +	as5011_update_axes(plat_dat);
>>>> +	mutex_unlock(&plat_dat->update_lock);
>>>
>>> Please explain this lock. Sorry if I have missed out your explanation in the earlier threads.
>>
>> If a second interruption occurs the first update must be finished before update again.
> 
> The ISR handler will not be called simultaneously on several CPUs. What
> else can it race with?
> 
Hum in fact nothing I thinks. I will delete it.

Thanks
Fabien
