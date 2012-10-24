Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822Ab2JXAdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:33:00 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:63726 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546Ab2JXAc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:32:59 -0400
Message-ID: <50873739.9030500@synaptics.com>
Date: Tue, 23 Oct 2012 17:32:57 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com> <20121011081351.GA32175@core.coreip.homeip.net> <50872C54.4090505@synaptics.com> <5515083.K7EXLgnYa6@dtor-d630.eng.vmware.com>
In-Reply-To: <5515083.K7EXLgnYa6@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 05:11 PM, Dmitry Torokhov wrote:
> On Tuesday, October 23, 2012 04:46:28 PM Christopher Heiny wrote:
>> On 10/11/2012 01:13 AM, Dmitry Torokhov wrote:
>>> On Thu, Oct 11, 2012 at 04:15:56AM +0000, Christopher Heiny wrote:
>>>> On Thursday, October 11, 2012 02:21:53 AM you wrote:
>>>>> On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com>
> wrote:

[snip]

>>>>>> +static int process_interrupt_requests(struct rmi_device *rmi_dev)
>>>>>> +{
>>>>>> +       struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
>>>>>> +       struct device *dev = &rmi_dev->dev;
>>>>>> +       struct rmi_function_container *entry;
>>>>>> +       u8 irq_status[data->num_of_irq_regs];
>>>>>
>>>>> Looking at this...
>>>>>
>>>>> What does the data->num_of_irq_regs actually contain?
>>>>>
>>>>> I just fear that it is something constant like always 2 or always 4,
>>>>> so there is actually, in reality, a 16 or 32 bit register hiding in
>>>>> there.
>>>>>
>>>>> In that case what you should do is to represent it as a u16 or u32 here,
>>>>> just or the bits into a status word, and then walk over that status
>>>>> word with something like ffs(bitword); ...
>>>>
>>>> Nope, it's not constant.  In theory, and RMI4 based sensor can have up
>>>> to 128 functions (in practice, it's far fewer), and each function can
>>>> have as many as 7 interrupts.  So the number of IRQ registers can vary
>>>> from RMI4 sensor to RMI4 sensor, and needs to be computed during the
>>>> scan of the product descriptor table.
>>>
>>> Is it a good idea to have it on stack then? Should it be part of
>>> rmi_device instead?
>>
>> It's not coming off the stack.  We're allocating it via devm_kzalloc()
>> in rmi_driver_probe().
>
> No, look at the part of the code that was quoted. "u8 irq_status[data-
> num_of_irq_regs];" is on stack.

Sorry - I thought you were referring to data->num_of_irq_regs rather 
than irq_status.  We'll move that.
