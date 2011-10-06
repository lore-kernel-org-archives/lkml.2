Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab1JFSff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:35:35 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:4757
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759061Ab1JFSfd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:35:33 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz9371K98dKzz1202hzz84d07hz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: "greg@kroah.com" <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver
 boilerplate
Thread-Topic: [RFC] drivercore: Add helper macro for platform_driver
 boilerplate
Thread-Index: AQHMhFa49fLPZi/8+U2QABzgZcrOMA==
Date: Thu, 6 Oct 2011 18:35:28 +0000
Message-ID: <CAOZdJXUF1tr37AuYLq6d+MP8ahWn7M1EE0jX9-6zYR0A3sSD4Q@mail.gmail.com>
References: <20111004232403.10364.22050.stgit@ponder>
In-Reply-To: <20111004232403.10364.22050.stgit@ponder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FBFFA39122AAD24F8BFA558080A1CA17@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 6:26 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
> index ae2cd1c..7795d4d 100644
> --- a/drivers/spi/spi-coldfire-qspi.c
> +++ b/drivers/spi/spi-coldfire-qspi.c
> @@ -621,20 +621,10 @@ static struct platform_driver mcfqspi_driver = {
>        .driver.name    = DRIVER_NAME,
>        .driver.owner   = THIS_MODULE,
>        .driver.pm      = MCFQSPI_DEV_PM_OPS,
> +       .probe          = mcfqspi_probe,
>        .remove         = __devexit_p(mcfqspi_remove),
>  };

So I had no idea that platform_driver_probe() existed.  It looks like
I function I should be using for SOC devices.  But I'm confused by one
thing.  That function says it's for non-hotpluggable devices.  I don't
see in module_platform_driver() where you honor that restriction.  It
looks like you're replacing the non-hotpluggable probe with a
hotpluggable probe.

-- 
Timur Tabi
Linux kernel developer at Freescale
