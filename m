Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab1ENOVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:21:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57804 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1ENOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WTEJan6vkgCLo7Zu9tiC7KzkRQnRuNODd/c0ycTnM+Wf2ejZbM5pfBTRFjVHF19f0J
         CiXbxDh0Zg6m2aKo8sCXHnbZDaqL3qCViDmXFZ5K3r5gM1dGXhKxXVPpduVApSBu1xkV
         6Oula8wVedborY2Ieyu1uJzXwPZwBYD7BiXQw=
MIME-Version: 1.0
In-Reply-To: <20110426094836.GD2659@sortiz-mobl>
References: <1303135451-26362-7-git-send-email-haojian.zhuang@marvell.com>
	<20110426094836.GD2659@sortiz-mobl>
Date: Sat, 14 May 2011 22:21:25 +0800
Message-ID: <BANLkTinpFBfOEOR6Ox1ufEHZo3qwRq8zhA@mail.gmail.com>
Subject: Re: [PATCH 06/14] mfd: pxa-w1: MFD driver for PXA 1wire control +
 DS1WM chip
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 5:48 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian,
>
> On Mon, Apr 18, 2011 at 10:04:03PM +0800, Haojian Zhuang wrote:
>> This driver provides registers and IRQ of PXA3xx chips to the ds1wm driver.
> I see why this is needed, but I really think the ds1wm driver should be
> converted to a regular platform device. The MFD driver below is just adding a
> useless middle layer between your platform code and the ds1wm one.
>
I'm OK to use the regulator platform device for ds1wm driver except
for one concern.
ds1wm driver is designed for mfd cell driver. I need to update it as
regulator platform
driver first. cell->enable() / cell->disable() is used to enable clock
for ds1wm driver.
So I need to change the API from cell->enable/disable to clk_enable()
/ clk_disable().

But the key issue is that there's no common structure for clkdev. Now
clkdev is only
designed for deeply machine depend.

>From my view is that we need a common structure for clkdev. Then mfd driver can
get benefit from this. Some client driver can be written as regulator
platform device.
And mfd driver can use them seamless. What's your opinion?

Best Regards
Haojian
