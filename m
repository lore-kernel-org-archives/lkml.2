Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab1GDNxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:53:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab1GDNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:53:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Date: Mon, 4 Jul 2011 15:53:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ryan Mallon <rmallon@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
References: <201106301441.24493.arnd@arndb.de> <4E11994B.7070103@gmail.com> <20110704110523.GB316@e-circ.dyndns.org>
In-Reply-To: <20110704110523.GB316@e-circ.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041553.07643.arnd@arndb.de>
X-Provags-ID: V02:K0:FUnoYK8Mg7cLieBTvkuS9oT55Tpg89MuqT5qLWyiTCI
 XJKZhP1J/nJBg1SpxWMoD8+5PwSfGOi0ukdmPzeVsQPI43ndNe
 nN7uh+3pYTV1wV9JTfmbdlreR8OiVGvcwdnnCQ4WP17Wf8dQYz
 P5xoW9kwuWuqKzVQc9FAx43EN+qxSZzeZm1qQaKMXUbwxZEtSY
 dcScpI8oII8hh1ThL/UhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 July 2011, Kurt Van Dijck wrote:
> > 
> > The pwm framework needs to incorporate at least the following:
> >  - sysfs access (ep93xx driver)
> >  - Multiple channels per device (atmel driver)
> 
> These are 2 very hardware dependant additions. Is this really the job
> for a framework to incorporate this?
> IMHO, the job of a framework is to allow such things. Creating a framework
> that does all special things of all vendors makes such thing
> complicated.

I think you shouldn't make it too easy for drivers to add extra
sysfs files. If at all possible, the default should be to add
them to the core, and define them in a way that makes sense for
future similar drivers.

We need to be careful to avoid a situation where multiple driver
writers introduce the same feature with a sysfs attribute, but do
so in an incompatible way.

> With socketCAN, we encountered a similar problem. Every chip maker
> tries to create added value by means of special options. You can't
> support them all in the framework. Therefore, sysfs can be added
> to configure special things.

I would expect that pwm is much simpler than CAN, so the amount
of creativity there is also limited.

	Arnd
