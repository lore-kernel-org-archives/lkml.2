Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2HTGpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:45:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57661 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2HTGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:45:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic pwm functions
Date: Mon, 20 Aug 2012 06:45:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com> <201208200537.48993.arnd@arndb.de> <A874F61F95741C4A9BA573A70FE3998F41EF092A@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF092A@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208200645.38047.arnd@arndb.de>
X-Provags-ID: V02:K0:jfcwKqF8f7KqdAgj8AdaLwOH8fhMGa1FibPlAu1ghIj
 YTEYVaj6NhPIJ7hpWpF2oVcmctJu5Z2521VcmJgd+HG3RccXpI
 gW7BL3CLN1acg59VSkfCDhkU5yPyEK3rRzFcY6q4DGoYzhfvoZ
 0g82PmbaelbTEnjm4h02f+bC1OBj29DWccoqWOasDf/lsiqjJT
 yJRirKs6BeBxw5/cDqxd9bbtUamm9ElPz+BU0IaPZCSwdCuq4E
 sKIIWbd9b0OGgkeeJ/fbpag4q8cwNhajKdW67zIQRv+OmOYZNq
 zPzKv2aNfW5n3QetRP9JEYQz/Nss7rHPonGtXhMn2GEPocjidO
 F+qRskvXkUBvuU3eeMno=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Kim, Milo wrote:
> > * I don't understand why you need the "if (rvdata->pwm) return 0;" case.
> >   It's normally better to do the initialization exactly once from the
> >   probe() function. You might want to return -EPROBE_DEFER if the pwm
> >   source is not yet available though.
> 
> This device has 3 control mode. - register access, sensor input and PWM input.
> One of modes can be selected on-the-fly.
> So that's why I add code which returning 0 when PWM device exists.
> Whenever mode change occurs from/to 'PWM input', pwm_request() and pwm_free() should be called.

In that case, I would recommend changing it from

+       /* if the pwm device exists, skip requesting the device */
+       if (drvdata->pwm)
+               return 0;

to 

	/* warn if the PWM was not released prior to reneabling it */
	WARN_ON(drvdata->pwm);


	Arnd
