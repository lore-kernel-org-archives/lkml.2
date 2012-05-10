Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2EJP50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:57:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2EJP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:57:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 02/12] pinctrl: basic Nomadik pinctrl interface
Date: Thu, 10 May 2012 15:57:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1336470270-23518-1-git-send-email-linus.walleij@stericsson.com> <CACRpkdZ+8n-E_8nyq-kO=Y+GYekkjiNXd3nzTqFnxLszpuKKPg@mail.gmail.com> <201205101553.11304.arnd@arndb.de>
In-Reply-To: <201205101553.11304.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205101557.12902.arnd@arndb.de>
X-Provags-ID: V02:K0:z5PqLFL1C9UGpeOMH2Ess6z47Ssba3uM8sIBL3tZHET
 KTvuvbTuOD50EjEz005B5EkK2WsH9eFLo18tEEw+URWUFsfuze
 hsSTSFkrnaJMcuENGmL7t9geUJiLjIFkAMHQSMdY2/k9zh50x3
 nX49dJCI9P8LzU5P2ynOsFeb48lubTh9Nl6P72hzMJfgtDb0zC
 TQSu4jhVsfKYGRwxD4d8cd7R75n5vbbz8V3+hojWVVSMI614Fp
 9kW5uMqkuTQZkLfbsvJylRnK7vAbLpZP7L62ZtueSwO6itR5tD
 FBt4ZJhYCxNKsPFpDDUSLm8J6MdTFjidQfYo7b9w9YGZJ9ux4V
 aExsGvVsbqpMfd3AxntQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012, Arnd Bergmann wrote:
> > >
> > > Arnd, what is your preferred design pattern of:
> > >
> > > A) sub-drivers that register one struct platform_driver per
> > >  variant, then calls into a shared core driver, or
> > >
> > > B) a shared core driver registering one platform_driver
> > >  with several struct platform_device_id that then call
> > >  sub-drivers depending on which one is found
> > >
> > > Either way is actually OK for me, but I was thinking if one
> > > is preferred over the other.
> 
> Out of those two, I'd always pick B.
> 
> In cases where the variants are different enough that you want to
> put them into separate files, I'd do
> 
> C) Make the common code one module that just exports symbols but
> registers no platform_driver at all, then put each variant into
> its own module that binds to one ID and calls the exported
> functions from the common module.
> 

Sorry, I guess A and C are actually the same and I just misread the
question.

So I'd use A for things that are different enough to put them
into separate files, and B for things where I'd always build
all variants in the same driver module anyway, e.g. when only
a few parameters are different.

	Arnd
