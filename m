Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2KFF1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:27:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:7515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab2KFF1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:27:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,720,1344236400"; 
   d="scan'208";a="213914171"
Date: Tue, 6 Nov 2012 13:27:29 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2] gpio: do not call __gpio_xxx under !CONFIG_GPIOLIB
Message-ID: <20121106052729.GR16883@yliu-dev.sh.intel.com>
References: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1351666855-23854-2-git-send-email-yuanhan.liu@linux.intel.com>
 <CACRpkdapHWJAMFn0hUQF52RjBz38MZzD3GS+5+pLfhsKJ+p_GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdapHWJAMFn0hUQF52RjBz38MZzD3GS+5+pLfhsKJ+p_GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 06:47:12PM +0100, Linus Walleij wrote:
> On Wed, Oct 31, 2012 at 8:00 AM, Yuanhan Liu
> <yuanhan.liu@linux.intel.com> wrote:
> 
> > Those functions are availabe only when CONFIG_GPIOLIB is set. So, we
> > should not call them under !CONFIG_GPIOLIB block.
> >
> > This would fix following build errros:
> > include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
> > include/asm-generic/gpio.h:220:2: error: implicit declaration of function '__gpio_get_value'
> > include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
> > nclude/asm-generic/gpio.h:226:2: error: implicit declaration of function '__gpio_set_value'
> 
> OK...
> 
> >  static inline int gpio_get_value_cansleep(unsigned gpio)
> >  {
> > -       might_sleep();
Hi,

> 
> So why are you deleting this very useful might_sleep() runtime
> semantic check?

Yes, I should keep it. I did it because I saw the definition of
gpio_get_value at include/linux/gpio.h didn't call that function.

Will keep it in the next version together with the previous patch.
And sorry that it may take some time, as I'm occupied by other things :(

Thanks.

	--yliu
> 
> > -       return __gpio_get_value(gpio);
> > +       WARN_ON(1);
> > +       return 0;
> >  }
> >
> >  static inline void gpio_set_value_cansleep(unsigned gpio, int value)
> >  {
> > -       might_sleep();
> > -       __gpio_set_value(gpio, value);
> > +       WARN_ON(1);
> >  }
> 
> Yours,
> Linus Walleij
