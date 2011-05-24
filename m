Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1EXFXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:23:51 -0400
Received: from smtp3.mail.ru ([94.100.176.131]:46298 "EHLO smtp3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab1EXFXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:23:48 -0400
Date: Tue, 24 May 2011 09:23:42 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH/RFC] gpio: add GPIOF_ values regardless on kconfig
 settings
Message-ID: <20110524052342.GA24918@rainbow>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
 <20110523134815.fb87933a.randy.dunlap@oracle.com>
 <20110523224659.GB19533@opensource.wolfsonmicro.com>
 <20110523155343.2e68c265.randy.dunlap@oracle.com>
 <20110524000837.GA30515@opensource.wolfsonmicro.com>
 <4DDB082F.3010107@oracle.com>
 <20110524014959.GA27710@opensource.wolfsonmicro.com>
 <4DDB3AFF.9030006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB3AFF.9030006@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:58 Mon 23 May     , Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
> is enabled by moving them to <linux/gpio.h>.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Looks good.

We probably may also want to move definition of struct gpio into
include/linux/gpio.h to make things like this work as well:

static struct gpio some_gpios[] = {
	{ GPIO_BLAH, GPIOF_IN, "BLAH"},
	{ GPIO_BLAH2, GPIOF_OUT_INIT_LOW, "BLAH2"},
};

static int some_init_function(void)
{
	/* ... */

	gpio_request_array(some_gpios, ARRAY_SIZE(some_gpios));

	/* ... */
}

These gpio_request_one() and gpio_request_array() are quite handy, so I
suppose more and more drivers will use it as we go...

-- 
Best regards,
Dmitry "MAD" Artamonow

