Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0JUQ0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:26:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37184 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0JUQ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J4G98kasXY/XH76k24Yp8gOe9r7H4YvOeIsg0J8y3DlWkJlewrNy1c8qO7OV0289uS
         wdaV9hrgSNrFt80iNcHRKLI8JcArhhGXIsnk7VnSSimDBpT+wtZAPBVIdxJxME8tq4z9
         DkOUXzog5s1lKnhkMgVNe93mUCW7unr+h5+us=
Date: Thu, 21 Oct 2010 20:26:17 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rklein@nvidia.com, broonie@opensource.wolfsonmicro.com, achew@nvidia.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
Message-ID: <20101021162617.GA10447@oksana.dev.rtsoft.ru>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1287676501-23254-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:
> This patch adds a simple driver for chargers indicating their online status
> through a GPIO pin.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Hm. I'm getting older, it seems. Now can anybody remind me why
pda_power.c doesn't work here? ;-)

This driver looks like a light-weigh version of pda_power, except
that it can do GPIOs directly (instead of is_*_online() callbacks).

Can we instead improve pda_power? Like this:

	if (!pdata->is_ac_online && pdata->ac_monitor_gpio)
		pdata->is_ac_online = pda_ac_monitor_gpio;

Should look quite cool, I think.

(Plus, we might get rid of ac/usb stuff in that driver, and 
pass enum power_supply_type to the callbacks instead).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
