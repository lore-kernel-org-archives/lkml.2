Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2LAXxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 18:53:14 -0500
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:45632 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab2LAXxN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 18:53:13 -0500
X-AuditID: 1209190f-b7fec6d00000090d-0f-50ba9867a2a3
Date: Sat, 1 Dec 2012 18:53:07 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Tejun Heo <tj@kernel.org>
cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
In-Reply-To: <20121201143926.GB2685@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1212011852100.25064@dr-wily.mit.edu>
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu> <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu> <20121130211435.GJ3873@htj.dyndns.org> <20121130225619.GD6021@htj.dyndns.org> <alpine.DEB.2.00.1211302234410.25064@dr-wily.mit.edu>
 <20121201143926.GB2685@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsUixCmqrJs+Y1eAwcLrZhb7NvJaXN41h83i
	zYo77BZbeyQsji0Qs/i1/CijA5vHt/eyHptWdbJ5XPm+mtHj8ya5AJYoLpuU1JzMstQifbsE
	rowvfSvZCl4yVZxsfcjcwDiXqYuRk0NCwETi59+b7BC2mMSFe+vZuhi5OIQE9jFKHLm+kgnC
	Wc8o0XLxKzuEs5tJ4sae+6wgLSwCWhKP7x8FG8UmoCYxd8NksFEiArISV6Y9ZARpYBY4xChx
	9fBisISwQLJES+cFMJtTwFjiefMSsGZeAUeJnoNLWSE2LGGSWHp3IxtIQlRAV2LvoTPsEEWC
	EidnPmEBsZkF1CUOfLrICGFrS9y/2cY2gVFwFpKyWUjKZiEpW8DIvIpRNiW3Sjc3MTOnODVZ
	tzg5MS8vtUjXRC83s0QvNaV0EyM48CX5dzB+O6h0iFGAg1GJhzfh4Y4AIdbEsuLK3EOMkhxM
	SqK86Q27AoT4kvJTKjMSizPii0pzUouB3uVgVhLhZTEByvGmJFZWpRblw6SkOViUxHmvptz0
	FxJITyxJzU5NLUgtgsnKcHAoSfDunQbUKFiUmp5akZaZU4KQZuLgBBnOAzR8FUgNb3FBYm5x
	ZjpE/hSjopQ4RLMASCKjNA+uF5aYXjGKA70izHsKpIoHmNTgul8BDWYCGvxm2XaQwSWJCCmp
	Bsb2eH2xcnbpX+8KsgWjec447EmRzfqmOGmJ2RIDtq3ZuYf/WhvlbBD41l6mUrDX+MNvJ+Uc
	OVuf3d8W8iaF/vx1rnaCwEdlt1e6JwR3h3y8697h+lOh/rP+lLC3kzW1+kR2Xt2czHlMeCnT
	484D2S1nuou95xyfNXPqK5PL676XXMnRURNkCFViKc5INNRiLipOBAAOiC0gJwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2012, Tejun Heo wrote:
> Can you please test this one too?  Thanks!
> 
> […]
> +	if (!delay) {
> +		__queue_work(cpu, wq, &dwork->work);
> +		return;
> +	}
> +
> […]
> -	if (!delay)
> -		return queue_work_on(cpu, wq, &dwork->work);
> -

Yes, this one fixes the bug too (on v3.7.0-rc7).

Anders
