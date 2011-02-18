Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab1BRB2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:28:55 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:47254 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1BRB2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:28:53 -0500
Message-ID: <4D5DCB46.9090506@wytron.com.tw>
Date: Fri, 18 Feb 2011 09:28:38 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tobias Klauser <tklauser@distanz.ch>
CC: nios2-dev@sopc.et.ntust.edu.tw, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [Nios2-dev] [PATHV v2] tty: serial: altera_uart: Add  devicetree
 support
References: <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch> <1297872732-10207-1-git-send-email-tklauser@distanz.ch> <4D5C86C1.8070404@wytron.com.tw> <20110217074846.GG4076@distanz.ch>
In-Reply-To: <20110217074846.GG4076@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 03:48 PM, Tobias Klauser wrote:
>>> +	ret = altera_uart_get_of_uartclk(pdev, port);
>>> +	if (ret&&   platp)
>>> +		port->uartclk = platp->uartclk;
>>> +	else if (ret)
>>> +		return ret;
>>> +
>>
>> Better reverse the priority, with platform data checked first.
>>
>> 	if (platp)
>> 		port->uartclk = platp->uartclk;
>> 	else {
>> 		ret = altera_uart_get_of_uartclk(pdev, port);
>> 		if (ret)
>> 			return ret;
>> 	}
>
> Do you have a specific reasoning for this? I thought it might make sense
> to do it in the same order as with the resources above, but I have no
> problem changing it to the way you suggest.

Not quite sure. But I see some drivers follow this order, and I just 
followed, too.

- Thomas
