Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0JEWDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:03:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117Ab0JEWDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:03:02 -0400
Date: Tue, 5 Oct 2010 15:02:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: rpurdie@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/4] leds: driver for National Semiconductor LP5521
 chip
Message-Id: <20101005150256.7769a8c7.akpm@linux-foundation.org>
In-Reply-To: <1285751405-22039-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1285751405-22039-1-git-send-email-samu.p.onkalo@nokia.com>
	<1285751405-22039-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 12:10:02 +0300
Samu Onkalo <samu.p.onkalo@nokia.com> wrote:

> +#define cdev_to_led(c)		container_of(c, struct lp5521_led, cdev)
> +#define engine_to_lp5521(eng)	container_of((eng), struct lp5521_chip, \
> +						engines[(eng)->id - 1])
> +#define led_to_lp5521(led)	container_of((led), struct lp5521_chip, \
> +						leds[(led)->id])

It would be better if these were implemented as C functions.  That would
make them cqearer, cleaner and more type-safe (container_of uses
typecasts in a way which makes it possible to misuse).

Also that would fix the bug which cdev_to_led(foo++) adds.

Similar improvements can be made to the other driver.  Also
SHIFT_MASK() and LE_ACTIVE() could become regular old lower-case C
functions, I think.

