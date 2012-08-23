Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293Ab2HWRTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:19:49 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43905 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964880Ab2HWRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:44 -0400
Message-ID: <50366628.5020007@metafoo.de>
Date: Thu, 23 Aug 2012 19:19:36 +0200
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
References: <36966374.2768747.1345741025741.JavaMail.root@advansee.com> <50366464.4070801@metafoo.de>
In-Reply-To: <50366464.4070801@metafoo.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 07:12 PM, Lars-Peter Clausen wrote:
>[...]
> Or maybe just use the runtime pm API for this. This probably makes even more
> sense and grab a reference to the pm context when the enable() is called,
> release it when disable() is called and also grab it before calling the
> device's config callback and release it afterward.

Btw. this seems to be exactly what the pwm-tiecap and pwm-tiehrpwm drivers
already do today. I'd just make that a core PWM framework feature.
