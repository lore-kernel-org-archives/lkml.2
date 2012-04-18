Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2DRVrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:47:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62489 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2DRVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:47:08 -0400
Date: Wed, 18 Apr 2012 14:47:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v7 1/6] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120418214703.GA31606@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
 <1332492784-10526-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1332492784-10526-2-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 05:52:58PM +0900, MyungJoo Ham wrote:
> External connector class (extcon) is based on and an extension of
> Android kernel's switch class located at linux/drivers/switch/.

<snip>

This patch breaks the build:
drivers/extcon/extcon_class.c:79:6: error: redefinition of ‘extcon_set_state’
include/linux/extcon.h:80:20: note: previous definition of ‘extcon_set_state’ was here
drivers/extcon/extcon_class.c:170:5: error: redefinition of ‘extcon_dev_register’
include/linux/extcon.h:67:19: note: previous definition of ‘extcon_dev_register’ was here
drivers/extcon/extcon_class.c:214:6: error: redefinition of ‘extcon_dev_unregister’
include/linux/extcon.h:73:20: note: previous definition of ‘extcon_dev_unregister’ was here

So it obviously can't be applied to the tree :(

Did you test it?

Care to redo this series and send it again?

greg k-h
