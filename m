Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966456Ab2JZUxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:53:01 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2475 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965143Ab2JZUxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:53:00 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Chris Brand" <chris.brand@broadcom.com>
To: "Tony Prisk" <linux@prisktech.co.nz>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>
cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v4] pwm: vt8500: Update vt8500 PWM driver support
Thread-Topic: [PATCH v4] pwm: vt8500: Update vt8500 PWM driver support
Thread-Index: AQHNsg8byW4pIJiUa06F4FONA3rtmZfMEn6A
Date: Fri, 26 Oct 2012 20:52:26 +0000
Message-ID: <4EE5B48738DDED408878C97C8E050A8B1BD17DD2@SJEXCHMB05.corp.ad.broadcom.com>
References: <1351100330-26072-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1351100330-26072-1-git-send-email-linux@prisktech.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7C94283F3OW10877676-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

> @@ -124,6 +156,12 @@ static int __devinit pwm_probe(struct
> platform_device *pdev)
>  	chip->chip.base = -1;
>  	chip->chip.npwm = VT8500_NR_PWMS;
> 
> +	chip->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR_OR_NULL(chip->clk)) {
> +		dev_err(&pdev->dev, "clock source not specified\n");
> +		return PTR_ERR(chip->clk);
> +	}
> +

Do you want IS_ERR() rather than IS_ERR_OR_NULL() here ?
Otherwise you may return PTR_ERR(NULL).

Chris


