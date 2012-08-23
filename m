Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab2HWPoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:44:14 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34948 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757078Ab2HWPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:44:11 -0400
Message-ID: <50364FA4.7000401@metafoo.de>
Date: Thu, 23 Aug 2012 17:43:32 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?QmVub8OudCBUaMOpYmF1ZGVhdQ==?= 
	<benoit.thebaudeau@advansee.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
References: <217877237.2758643.1345731587941.JavaMail.root@advansee.com>
In-Reply-To: <217877237.2758643.1345731587941.JavaMail.root@advansee.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 04:19 PM, Benoît Thébaudeau wrote:
> Some PWM drivers enable the clock of the PWM peripheral in pwm_enable(). Hence,
> for these drivers, a call to pwm_config() does not have any effect before
> pwm_enable() has been called.
> 
> This patch fixes the PWM users to make sure that they call pwm_enable() before
> pwm_config().
> 
> This fixes the first setting of brightness through sysfs that had no effect with
> leds-pwm and the i.MX PWM driver.

But isn't this a bug in the PWM peripheral driver? With this change the PWM
will start with the old settings first. While this is not so much of a problem
for a backlight (although it might cause a short flickering) it might cause
problems for other applications, like using the PWM pin as a timing generator.
In my opinion it's better to fix the PWM peripheral drivers which have this
problem instead of trying to work around it in every user of the PWM API.

- Lars
