Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab2JSIpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:45:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55183 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796Ab2JSIpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:45:33 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] lp855x_bl: use generic PWM functions
Thread-Topic: [PATCH 1/2] lp855x_bl: use generic PWM functions
Thread-Index: Ac2t0WMMFWO85huLQxOk73R4nJPZTf//fH2A//93V7A=
Date: Fri, 19 Oct 2012 08:45:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641791BB@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F6417916D@DQHE02.ent.ti.com>
 <20121019082107.GA20659@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121019082107.GA20659@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Generally this looks good. Obviously you'll need to update any users of
> this driver as well. It might make sense to include those changes in
> this patch to avoid interim build failures.

Thanks for your review.
So far no usages for this driver in the mainline.
I've tested it in my own development environment instead.

> Other than that I have just one smaller comment below.
> 
> > +	pwm_config(lp->pwm, duty, period);
> > +	duty == 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
> 
> This is really ugly and should be written explicitly:
> 
> 	if (duty == 0)
> 		pwm_disable(lp->pwm);
> 	else
> 		pwm_enable(lp->pwm);

Oh, I prefer using '?' to if-sentence because it looks clear to me.
But if it's difficult to read/understand, I'll fix it.
I'd like to have others' opinion.

Thank you

Best Regards,
Milo 
