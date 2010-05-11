Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0EKIbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:31:18 -0400
Received: from mail175c2.megamailservers.com ([69.49.111.75]:37002 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757201Ab0EKIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:31:13 -0400
X-Greylist: delayed 4358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 04:31:12 EDT
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4BE90339.8080304@gaisler.com>
Date: Tue, 11 May 2010 09:11:53 +0200
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] [OOPS] apbuart.c: Two problems related to 	grlib_apbuart_configure()
References: <1273355935.13191.6.camel@carter> <AANLkTikatJDpPHw8WeE7XwLVgeg4A1Atd2ARoJxomzzl@mail.gmail.com>
In-Reply-To: <AANLkTikatJDpPHw8WeE7XwLVgeg4A1Atd2ARoJxomzzl@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CHA: v=1.1 cv=nfV7DS5/VNjzlYjkqXMAjlC4PTaANdlvmbFYHgeV1+I= c=1 sm=1
		a=1lW1l16fd8MA:10 a=8nJEP1OIZ-IA:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=pGLkceISAAAA:8 a=ebG-ZW-8AAAA:8 a=3IBxSe9sY0x7h2diX3gA:9
		a=fqdn7FbnFedNmeOsYQ4A:7 a=TrR_IHwmzoCGxUjmz83AVDhRgO8A:4 a=wPNLvfGTeEIA:10
		a=MSl-tDqOz04A:10 a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ojeda wrote:
> On Sat, May 8, 2010 at 11:58 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> Hi,
>>
>> I found two problems using the Simics' sunfire target, so maybe the
>> following does not occur in real machines.
>>
>> 1. At grlib_apbuart_configure() in apbuart.c, prop can be NULL if
>> "clock-frequency" doesn't exist in the OF tree:
>>
>>        /* Get bus frequency */
>>        rp = of_find_node_by_path("/");
>>        rp = of_get_next_child(rp, NULL);
>>        prop = of_get_property(rp, "clock-frequency", NULL);
>>        freq_khz = *prop;
>>
>> 2. In addition, apbuart.c does not check if there aren't any ports
>> configured after calls to grlib_apbuart_configure(), so other oops will
>> occur if no port was configured (e.g. uart_set_options() because of
>> port->ops).
>>
>> In order to solve that, I added a check after both of the calls to
>> grlib_apbuart_configure().
>>
>> The patch that I provide below prevents both problems in the Simics'
>> sunfire target.
>>
>> Tested against 2.6.33.3. Please review.
>>
>> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>


Thanks for the patch, it looks fine to me. 

Acked-by: Kristoffer Glembo <kristoffer@gaisler.com>


