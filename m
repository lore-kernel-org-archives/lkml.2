Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab2JIHrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:47:07 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:44309
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257Ab2JIHrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:47:01 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzz6d524h8275bh8275dhz2dh2a8h668h839hd25he5bhf0ah107ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <5073D77B.7060802@analog.com>
Date: Tue, 9 Oct 2012 09:51:23 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: use module_i2c_driver to simplify the code
References: <CAPgLHd8ONvLXiAZG5brCuATwkyUW2MbWPwS9rQZn7Sru7qmFGw@mail.gmail.com>
In-Reply-To: <CAPgLHd8ONvLXiAZG5brCuATwkyUW2MbWPwS9rQZn7Sru7qmFGw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 04:09 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use the module_i2c_driver() macro to make the code smaller
> and a bit simpler.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/mfd/adp5520.c | 12 +-----------
>   1 file changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index ea8b947..94e7a6d 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -360,17 +360,7 @@ static struct i2c_driver adp5520_driver = {
>   	.id_table 	= adp5520_id,
>   };
>   
> -static int __init adp5520_init(void)
> -{
> -	return i2c_add_driver(&adp5520_driver);
> -}
> -module_init(adp5520_init);
> -
> -static void __exit adp5520_exit(void)
> -{
> -	i2c_del_driver(&adp5520_driver);
> -}
> -module_exit(adp5520_exit);
> +module_i2c_driver(adp5520_driver);
>   
>   MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>   MODULE_DESCRIPTION("ADP5520(01) PMIC-MFD Driver");
>
>


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


