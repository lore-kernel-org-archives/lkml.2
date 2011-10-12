Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1JLPfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:35:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52927 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1JLPfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:35:32 -0400
Message-ID: <4E95B3AA.9040603@atmel.com>
Date: Wed, 12 Oct 2011 17:35:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty/serial: atmel_serial: add device tree support
References: <1317635502-9430-1-git-send-email-nicolas.ferre@atmel.com> <4E8A6858.6020700@gmail.com> <20111004165226.GA10919@ponder.secretlab.ca>
In-Reply-To: <20111004165226.GA10919@ponder.secretlab.ca>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 06:52 PM, Grant Likely :
> On Mon, Oct 03, 2011 at 08:58:48PM -0500, Rob Herring wrote:
>> On 10/03/2011 04:51 AM, Nicolas Ferre wrote:
>>>  static int __devinit atmel_serial_probe(struct platform_device *pdev)
>>>  {
>>>  	struct atmel_uart_port *port;
>>> +	struct device_node *np = pdev->dev.of_node;
>>>  	struct atmel_uart_data *pdata = pdev->dev.platform_data;
>>>  	void *data;
>>>  	int ret;
>>>  
>>>  	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
>>>  
>>> -	port = &atmel_ports[pdata->num];
>>> +	if (np) {
>>> +		ret = of_alias_get_id(np, "serial");
>>> +		if (ret < 0)
>>> +			goto err;
>>
>> I'll defer to Grant on this. There aren't any other drivers using this.
>>
> 
> This is the correct thing to do.
> 
> One note however; I prefer driver to *not* require an alias to be
> present.  By all means, use an alias if it is available, but the
> driver should auto-enumerate if it is not.  There is a patch that
> makes of_alias_get_id() do this for you, but it hasn't been mainlined
> yet and it is still a bit in flux.  There will be something that takes
> care of this for you, but be aware that the function name may change.
> 
> In the mean time, this patch is okay.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Grant,

I have reworked this atmel_serial device tree support so I did not add
your "Acked-by" to this new series. I repost it right now.
I hope this new implementation will be even better though ;-)

Bye,
-- 
Nicolas Ferre
