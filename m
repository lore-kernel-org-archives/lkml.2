Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab2HXNUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:20:46 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:18186 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2HXNUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:20:43 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QOb9J0FJuBIaYwpbJL5Q==
X-RZG-CLASS-ID: mo05
Message-ID: <50377E38.1040701@denx.de>
Date: Fri, 24 Aug 2012 15:14:32 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Julia Lawall <Julia.Lawall@lip6.fr>, Shiraz Hashim <shiraz.hashim@st.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/devices/spear_smi.c: use devm_ functions
 consistently
References: <1344112598-1051-1-git-send-email-Julia.Lawall@lip6.fr> <1345808104.2848.285.camel@sauron.fi.intel.com>
In-Reply-To: <1345808104.2848.285.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 01:35 PM, Artem Bityutskiy wrote:
>> @@ -1073,21 +1043,13 @@ static int __devexit spear_smi_remove(struct platform_device *pdev)
>>  		ret = mtd_device_unregister(&flash->mtd);
>>  		if (ret)
>>  			dev_err(&pdev->dev, "error removing mtd\n");
>> -
>> -		iounmap(flash->base_addr);
>> -		kfree(flash);
>>  	}
>>  
>>  	irq = platform_get_irq(pdev, 0);
>> -	free_irq(irq, dev);
> 
> I guess 'platform_get_irq()' should be killed as well? Stefan, this is
> strange code - we get irq, without checking for error, and then free it?
> What is the rationale?

Yes, this seems bogus. platform_get_irq() definitely should be removed
from spear_smi_remove().

>>  	clk_disable_unprepare(dev->clk);
>> -	clk_put(dev->clk);
>> -	iounmap(dev->io_base);
>> -	kfree(dev);
>>  
>>  	smi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -	release_mem_region(smi_base->start, resource_size(smi_base));
>>  	platform_set_drvdata(pdev, NULL);
> 
> Why do we set platform data to NULL, is this needed?

It seems to be common practice to use this call to clear the drvdata in
the driver remove function. I have to admit, that I'm not sure if its
really needed though.

Thanks,
Stefan
