Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0CYOGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:06:04 -0400
Received: from server78.greatnet.de ([83.133.96.102]:33293 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0CYOGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:06:01 -0400
Message-ID: <4BAB6DC1.4020507@nachtwindheim.de>
Date: Thu, 25 Mar 2010 15:05:53 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: isdn@linux-pingi.de, davem@davemloft.net, linux@dominikbrodowski.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de> <20100325121610.GB5069@pengutronix.de>
In-Reply-To: <20100325121610.GB5069@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang schrieb:
> Hi Henrik,
>
> thanks for the work. Please, just keep the placement of those attributes
> consistent. Otherwise it might be easy to miss:
>
>   
>> -static int sedlbauer_config(struct pcmcia_device *link);
>> +static int sedlbauer_config(struct pcmcia_device *link) __devinit ;
>>     
>
> Wrong.
>
>   
>> -static int sedlbauer_probe(struct pcmcia_device *link)
>> +static int __devinit sedlbauer_probe(struct pcmcia_device *link)
>>  {
>>     
>
> Right.
>
> (I think checkpatch checks for this, too)
>
> Regards,
>
>    Wolfram
>   
 Hi there, 

 Imho should these functions be reorderd, so that no prototypes are required in a driver file.
 If somebody wishes, I would do that for those.

 For the prototypes I was following init.h, heres a snippet:

 * Usage:
 * For functions:
 * 
 * You should add __init immediately before the function name, like:
 *
 * static void __init initme(int x, int y)
 * {
 *    extern int z; z = x * y;
 * }
 *
 * If the function has a prototype somewhere, you can also add
 * __init between closing brace of the prototype and semicolon:
 *
 * extern int initialize_foobar_device(int, int, int) __init;
 *


