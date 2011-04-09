Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1DIHyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 03:54:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54314 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1DIHyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 03:54:09 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.51.37]
In-Reply-To: <1302294509-6595-1-git-send-email-mathieu.poirier@linaro.org>
References: <1302294509-6595-1-git-send-email-mathieu.poirier@linaro.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 9 Apr 2011 10:53:48 +0300
Message-ID: <BANLkTikMy7vpz8z479sCuROgjV8EK03FUQ@mail.gmail.com>
Subject: Re: [PATCH] ux500: Adding support for u8500 Hsem functionality.
To: mathieu.poirier@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, lee.jones@linaro.org,
        patches@linaro.org, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Fri, Apr 8, 2011 at 11:28 PM,  <mathieu.poirier@linaro.org> wrote:
...

> + * Author: Mathieu Poirier <mathieu.poirier@linaro.org>
> + * Heavily borrowed from the work of :
> + *   Simon Que <sque@ti.com>
> + *   Hddari Kanigeri <h-kanigeri2@ti.com>

s/Hddari/Hari/

> +       platform_set_drvdata(pdev, state);
> +
> +       /* no pm needed for HSem but required to comply
> +        * with hwspilock core.
> +        */
> +       pm_runtime_enable(&pdev->dev);

You seem to have removed the calls to pm_runtime_disable() throughout
the driver, is that on purpose ?

You should see an "Unbalanced pm_runtime_enable!" warning about this
if you tried rmmod'ing and insmod'ing the driver again.

And just a minor comment if you're submitting a v2: you have a bunch
of trailing whitespaces; try checkpatch to spot them easily.

Thanks,
Ohad.
