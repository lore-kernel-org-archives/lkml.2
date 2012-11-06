Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2KFGqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 01:46:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57414 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2KFGqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 01:46:30 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Philip, Avinash" <avinashphilip@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 6/8] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Thread-Topic: [PATCH 6/8] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Thread-Index: AQHNuzkObRJcVQIrV0aW80ulyIj5J5fcXT2w
Date: Tue, 6 Nov 2012 06:46:13 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC04483@DBDE01.ent.ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
 <1352106749-9437-7-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1352106749-9437-7-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 14:42:27, Philip, Avinash wrote:
[...]

> +	/* Some platforms require explicit tbclk gating */
> +	if (of_property_read_bool(pdev->dev.of_node, "tbclkgating")) {
> +		pc->tbclk = clk_get(&pdev->dev, "tbclk");
> +		if (IS_ERR(pc->tbclk)) {
> +			dev_err(&pdev->dev, "Could not get EHRPWM TBCLK\n");
> +			return PTR_ERR(pc->tbclk);
> +		}
> +	}
> +
> +	/* Enable tbclk & leave */
> +	if (pc->tbclk)
> +		clk_enable(pc->tbclk);
> +

Here also why are you leaving this clock always running?

Regards,
Vaibhav
