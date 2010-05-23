Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0EWCRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 22:17:24 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:55982 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0EWCRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 22:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Dn2S77izP6Iz+vHYdre9Yas9eGBPU7eHw+VvriIpswCsKO01jaDM+DP8vMalLKdC4m
         WrhxoThJib+zaUJEBgARx2yBnAVbTdbWbeu3YIa2zcyCj6kYQff7IWzRdUX6DhgPn/tO
         DjsBifs6u46NPU+vtoe7X31m4WA3NYr6bKQUc=
MIME-Version: 1.0
In-Reply-To: <1269567614-26995-1-git-send-email-henne@nachtwindheim.de>
References: <1269567614-26995-1-git-send-email-henne@nachtwindheim.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 22 May 2010 22:17:02 -0400
Message-ID: <AANLkTimWhBfb4yiq8CEmrEoJpaNOEnTUihaRWaUTVV_N@mail.gmail.com>
Subject: Re: [PATCH] mfd: section cleanup of 88pm860x driver
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 21:40, Henrik Kretzschmar wrote:
_device_init(struct pm860x_chip *chip,
> -                             struct pm860x_platform_data *pdata);
> -extern void pm860x_device_exit(struct pm860x_chip *chip);
> +                             struct pm860x_platform_data *pdata) __devinit ;
> +extern void pm860x_device_exit(struct pm860x_chip *chip) __devexit ;
>
>  #endif /* __LINUX_MFD_88PM860X_H */

i took a second look and noticed that this hunk is useless.  as long
as the func definitions have proper markings, the prototypes wrt
section markings here is irrelevant.  plus, you add a spurious space
before the semicolon.
-mike
