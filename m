Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2JAO6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:58:42 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:39665 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751193Ab2JAO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:58:38 -0400
Message-ID: <5069AF8C.2070807@ti.com>
Date: Mon, 01 Oct 2012 20:28:20 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        santosh.shilimkar@ti.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCHv3 2/4] Input: keypad: Add smsc ece1099 keypad driver
References: <1349089310-22134-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1349089310-22134-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2012 04:31 PM, Sourav Poddar wrote:
> +smsc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct smsc *smsc = dev_get_drvdata(pdev->dev.parent);
> +	struct input_dev *input;
> +	struct smsc_keypad *kp;
> +	int ret = 0, error;
> +	int col, i, max_keys, row_shift;
> +	int irq;
> +	int addr;
> +
> +	kp = devm_kzalloc(dev, sizeof(*kp), GFP_KERNEL);
> +
> +	input = input_allocate_device();
> +	if (!kp || !input) {
> +		error = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	error = smsc_keypad_parse_dt(&pdev->dev, kp);
> +	if (error)
> +		return error;
>
Are we leaking input here?
