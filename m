Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2HFUFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:05:05 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55390 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2HFUFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:05:02 -0400
X-pt: isis.lip6.fr
Message-ID: <20120806215319.61694sx9o05uxm68@webmail.lip6.fr>
Date: Mon, 06 Aug 2012 21:53:19 +0200
From: Julia.Lawall@lip6.fr
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc
 and devm_clk_get
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr>
 <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda>
 <501FD69D.7070702@metafoo.de>
In-Reply-To: <501FD69D.7070702@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-15;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.11)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (isis.lip6.fr [132.227.60.2]); Mon, 06 Aug 2012 21:53:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lars-Peter Clausen <lars@metafoo.de>:

> On 08/06/2012 04:26 PM, Dan Carpenter wrote:
>> On Mon, Aug 06, 2012 at 05:23:23PM +0300, Dan Carpenter wrote:
>>> On Sat, Aug 04, 2012 at 08:23:27PM +0200, Julia Lawall wrote:
>>>> @@ -922,12 +920,7 @@ static int emmaprp_probe(struct  
>>>> platform_device *pdev)
>>>>
>>>>  	platform_set_drvdata(pdev, pcdev);
>>>>
>>>> -	if (devm_request_mem_region(&pdev->dev, res_emma->start,
>>>> -	    resource_size(res_emma), MEM2MEM_NAME) == NULL)
>>>> -		goto rel_vdev;
>>>> -
>>>> -	pcdev->base_emma = devm_ioremap(&pdev->dev, res_emma->start,
>>>> -					resource_size(res_emma));
>>>> +	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
>>>>  	if (!pcdev->base_emma)
>>>>  		goto rel_vdev;
>>>
>>> This was in the original code, but there is a "ret = -ENOMEM;"
>>> missing here, and again a couple lines down in the original code.
>>>
>>
>> Or should that be -EIO instead of -ENOMEM?  I'm not sure.
>
> -ENXIO is usually used in such a case.

Thanks for the feedback.  I won't be able to access my work machine  
until the end of the week, so I will fix it then.

julia



