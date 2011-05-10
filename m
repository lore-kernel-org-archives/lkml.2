Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab1EJIWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:22:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64891 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab1EJIWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tzkAmIXFTNXCrG5YtKISV8LSLhuvDwnsVOCBpRPIRUla+7GBMPummMJUuLVgE98OkA
         WIieGwgssBYvNPI6Vh39SuBFT7BPNkq9QAObTrtLaNbRWXgscYDu1OKEvm2vRHWdh054
         sK0cQEKZS8g1F2f8UcwHT0iYsWYQ2huI/vopQ=
MIME-Version: 1.0
In-Reply-To: <201105082322.44268.rjw@sisk.pl>
References: <201104290154.12966.rjw@sisk.pl>
	<201105082320.57185.rjw@sisk.pl>
	<201105082322.44268.rjw@sisk.pl>
Date: Tue, 10 May 2011 16:22:00 +0800
Message-ID: <BANLkTin49iSYn=r8G=L0S2vnZhtZw6RFpw@mail.gmail.com>
Subject: Re: [PATCH 1/5] PM / Runtime: Support for generic I/O power domains (v3)
From: Lin Ming <minggr@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 5:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>

> +
> +/**
> + * __pm_genpd_restore_device - Restore a pre-suspend state of a device.
> + * @dev: Device to restore the state of.
> + * @genpd: Power domain the device belongs to.
> + */
> +static void __pm_genpd_restore_device(struct device *dev,
> +                                     struct generic_power_domain *genpd)
> +{
> +       struct device_driver *drv = dev->driver;
> +
> +       if (genpd->start_device)
> +               genpd->start_device(dev);
> +
> +       if (drv && drv->pm && drv->pm->runtime_resume)
> +               drv->pm->runtime_resume(dev);
> +
> +       if (genpd->stop_device)
> +               genpd->stop_device(dev);
> +}

Why call ->stop_device in restore function?

BTW,
you implemented power domains for ARM / shmobile,
What can we do for other arches?
I wonder how to implement this "power domain" on x86.

Thanks,
Lin Ming
