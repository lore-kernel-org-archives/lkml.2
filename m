Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab1JGWKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:10:02 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37500 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1JGWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:10:00 -0400
MIME-Version: 1.0
In-Reply-To: <20111007110615.7638e905@lxorguk.ukuu.org.uk>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-5-git-send-email-manjugk@ti.com> <20111007110615.7638e905@lxorguk.ukuu.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 7 Oct 2011 16:09:38 -0600
X-Google-Sender-Auth: DvkMkLI9TqMhpYYdngGhiKMEY7Y
Message-ID: <CACxGe6tmjQGw77NMNYLWJHMAtmF9fk_9HnHtbrMhzkKEC1HG=Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] gpiolib: handle deferral probe error
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>, Dilan Lee <dilee@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 4:06 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 07 Oct 2011 10:33:09 +0500
> "G, Manjunath Kondaiah" <manjugk@ti.com> wrote:
>
>>
>> The gpio library should return -EPROBE_DEFER in gpio_request
>> if gpio driver is not ready.
>
> Why not use the perfectly good existing error codes we have for this ?
>
> We have EAGAIN and EUNATCH both of which look sensible.

I want a distinct error code for probe deferral so that a) it doesn't
overlap with something a driver is already doing, and b) so that all
the users can be found again at a later date.

That said, I'm not in agreement with this patch.  It is fine for gpio
lib to have a code that means the pin doesn't exist (yet), but the
device driver needs to be the one to decide whether or not it is
appropriate to use probe deferral.

g.
