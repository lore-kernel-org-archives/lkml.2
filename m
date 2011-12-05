Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1LEIzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:55:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:54019 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1LEIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:55:18 -0500
Message-ID: <4EDC86F1.2070301@linutronix.de>
Date: Mon, 05 Dec 2011 09:55:13 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: balbi@ti.com
CC: Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
Subject: Re: [RFC] UASP on target
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org> <20111205082047.GA2423@linutronix.de> <20111205082326.GA2734@linutronix.de> <20111205083946.GE9900@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111205083946.GE9900@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 09:39 AM, Felipe Balbi wrote:
> Hi,
Hi,

> On Mon, Dec 05, 2011 at 09:23:26AM +0100, Sebastian Andrzej Siewior wrote:
>> * Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
>>
>>> * Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
>>>
>>>> This patch implements the infrastructure for the UAS gadget driver.
>>>> The UAS gadget driver registers as a second configuration of the MS
>>>> gadet driver.
>>> hch said to use target framework and you haven't done so. This is what I
>>> have so far. It is not yet complete. What I need to do is:
>>> - wire up command processing (currently here)
>>> - wire up data processing
>>> - check it works =>  post v1
>>> - wire up command tagging =>  v2
>>> - remove hard codings and fix whatever people complained about.
>
> This is much better, indeed, but the way it is now, it's only usable by
> the gadget framework because you have put the function driver on the
> transport layer. I wonder if there wouldn't be a simple way to split the
> "SCSI Over USB" part in a more generic way which could be shared between
> gadget side UASP and host side UASP drivers ?!? Maybe ?!?
>
> The drivers/target/uasp_*.c would really be just a transport layer and
> gadget/host drivers would make calls to that "library" ? Something like
> that ??

There is very little code that is not host specific. For instance
uas_alloc_cmd_urb() is something that could be used on both side but
the host is boxing the command and I need to unbox it. So I don't see
how I could share things except for the defines.
Most of the things are usb specific. So UAS gets the commands from the
scsi framework, puts the usb layer around it and sends them.

Sebastian
