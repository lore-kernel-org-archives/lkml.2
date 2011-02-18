Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1BRIJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:09:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57127 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1BRIJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:09:14 -0500
MIME-Version: 1.0
In-Reply-To: <4D5DCB46.9090506@wytron.com.tw>
References: <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch>
 <1297872732-10207-1-git-send-email-tklauser@distanz.ch> <4D5C86C1.8070404@wytron.com.tw>
 <20110217074846.GG4076@distanz.ch> <4D5DCB46.9090506@wytron.com.tw>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 Feb 2011 01:08:53 -0700
X-Google-Sender-Auth: jMsh4uUqBtRzBLXDbTGkvSTpvJQ
Message-ID: <AANLkTinDD71YQbYovBSwU8YSCCZ56wQf35X97WFoY6R9@mail.gmail.com>
Subject: Re: [Nios2-dev] [PATHV v2] tty: serial: altera_uart: Add devicetree support
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Tobias Klauser <tklauser@distanz.ch>, nios2-dev@sopc.et.ntust.edu.tw,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 6:28 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> On 02/17/2011 03:48 PM, Tobias Klauser wrote:
>>>>
>>>> +       ret = altera_uart_get_of_uartclk(pdev, port);
>>>> +       if (ret&&   platp)
>>>> +               port->uartclk = platp->uartclk;
>>>> +       else if (ret)
>>>> +               return ret;
>>>> +
>>>
>>> Better reverse the priority, with platform data checked first.
>>>
>>>        if (platp)
>>>                port->uartclk = platp->uartclk;
>>>        else {
>>>                ret = altera_uart_get_of_uartclk(pdev, port);
>>>                if (ret)
>>>                        return ret;
>>>        }
>>
>> Do you have a specific reasoning for this? I thought it might make sense
>> to do it in the same order as with the resources above, but I have no
>> problem changing it to the way you suggest.
>
> Not quite sure. But I see some drivers follow this order, and I just
> followed, too.

The reason to check for platform_data first is that if a device has
*both* platform data and a device node pointer, then more than likely
the platform_data is indented to override the device node data.

g.
