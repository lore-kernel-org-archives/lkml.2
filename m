Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0CTH44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 03:56:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43607 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0CTH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 03:56:54 -0400
X-Auth-Info: 006NIwdRGlGMYn5nL+aAQunDhiSbT4Xq6R0WQf8wuPU=
Message-ID: <4BA47F64.8030108@grandegger.com>
Date: Sat, 20 Mar 2010 08:55:16 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN	module
References: <> <1268930324-29841-3-git-send-email-iws@ovro.caltech.edu> <4BA33D5A.8070000@grandegger.com> <20100319151914.GB13672@ovro.caltech.edu> <4BA39C05.8050800@grandegger.com> <20100319200325.GE13672@ovro.caltech.edu> <4BA3DAF1.4090206@grandegger.com> <20100319215227.GF13672@ovro.caltech.edu>
In-Reply-To: <20100319215227.GF13672@ovro.caltech.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira W. Snyder wrote:
> On Fri, Mar 19, 2010 at 09:13:37PM +0100, Wolfgang Grandegger wrote:
>> Ira W. Snyder wrote:
>>> On Fri, Mar 19, 2010 at 04:45:09PM +0100, Wolfgang Grandegger wrote:
>>>> Ira W. Snyder wrote:
>>>>> On Fri, Mar 19, 2010 at 10:01:14AM +0100, Wolfgang Grandegger wrote:
>>>>>> Hi Ira,
>>>>>>
>>>>>> we already discussed this patch on the SocketCAN mailing list and there
>>>>>> are just a few minor issues and the request to add support for the new
>>>>>> "berr-reporting" option, if feasible. See:
>>>>>>
>>>>>>   commit 52c793f24054f5dc30d228e37e0e19cc8313f086
>>>>>>   Author: Wolfgang Grandegger <wg@grandegger.com>
>>>>>>   Date:   Mon Feb 22 22:21:17 2010 +0000
>>>>>>
>>>>>>     can: netlink support for bus-error reporting and counters
>>>>>>     
>>>>>>     This patch makes the bus-error reporting configurable and allows to
>>>>>>     retrieve the CAN TX and RX bus error counters via netlink interface.
>>>>>>     I have added support for the SJA1000. The TX and RX bus error counters
>>>>>>     are also copied to the data fields 6..7 of error messages when state
>>>>>>     changes are reported.
>>>>>>
>>>>>> Should not be a big deal.
>>>>>>
>>>>> I think this patch came along since my last post of the driver. I must
>>>>> have missed it. I'll try and add support.
>>>> No problem, it's really new. Just just need to enable BEI depending on
>>>> CAN_CTRLMODE_BERR_REPORTING.
>>>>
>>> I have one final question about this.
>>>
>>> The documentation for the firmware isn't very specific here. I believe
>>> that in order to get any kind of error messages, I need the bus error
>>> feature turned on. What is the expected behavior of an SJA1000 with the
>>> BEI (bus error interrupt) turned off? Will you still get warning
>>> messages for ERROR_ACTIVE -> ERROR_PASSIVE state transitions?
>> Yes. State transitions are enabled with EI and EPI.
>>
> 
> I cannot set the registers directly, but I think I got it right. See
> below.
> 
>>> I'm not sure how I would go about testing this feature, either. Ideas?
>> Send messages without cable connected and watch the error messages with
>> "candump any,0:0,#ffffffff". With "ip ... berr-reporting on" you should
>> see additional bus-errors.
>>
> 
> Ok, I tried this. On one controller, I turned on bus-error reporting. On
> the other, I turn off bus-error reporting. I then tried sending lots of
> messages with the cable unplugged. Here is what happened:
> 
> bus-error reporting on:
> Lots of CAN_ERR_BUSERR messages are flooded in candump. There is also a
> CAN_ERR_CRTL_TX_WARNING message, when there are too many TX errors.

OK, you will now also understand why bus-error reporting is off by
default. On low-end systems bus-error flooding may even hang the system.

> bus-error reporting off:
> There was only one message reported before the controller went into
> ERROR-WARNING state. It was the same CAN_ERR_CRTL_TX_WARNING message as
> above. There was no flooding of CAN_ERR_BUSERR messages.
> 
> Does this seem right? It seems pretty good to me.

Yes, I'm just missing an error-passive message. What state does "ip -d
link show can0" report.

>>> I also noticed that I can enable "self test mode" and "listen only mode"
>>> using the same firmware command. It appears that there are netlink
>>> messages for this as well. Should I try and support these, too? I don't
>>> really have any use for them (yet). I assume "self test mode" is
>>> equivalent to "loopback mode" in the netlink messages.
>> List-only is straight forward while "self test mode" is not exactly like
>> "loopback mode", IIRC. Feel free to send a follow-up patch when you have
>> time for a thorough implementation and testing. It's also on my to-do
>> list for the SJA1000.
>>
> 
> Ok, then I'll put this off for a while. Feel free to pester me about it
> when there is a working implementation in the SJA1000 driver for me to
> borrow from. :)

I will let you know when I have something working.

Wolfgang.
