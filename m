Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1FNSIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:08:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab1FNSIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:08:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, grant@secretlab.ca
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Date: Tue, 14 Jun 2011 19:08:32 +0100
Message-ID: <5194.1308074912@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Allow people to use gpiolib on FRV, mostly for build coverage as it
> seems more useful to standardise the API than handle making it optional.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Nack.

There's an ordering problem.  The #inclusion of asm-generic/gpio.h must come
both before *and* after the functions in asm/gpio.h.  Take gpio_get_value()
for instance, it requires __gpio_get_value() - which is defined by the generic
header - but is used by gpio_get_value_cansleep() in the generic header.

You must split asm-generic/gpio.h.

David
