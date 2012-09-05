Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab2IEAi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:38:56 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:26918 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2IEAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:38:54 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 04 Sep 2012 17:10:33 -0700
Message-ID: <50469F1D.5000508@synaptics.com>
Date: Tue, 4 Sep 2012 17:38:53 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC PATCH 17/17] input: RMI4 F54 analog data reporting
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <1345241877-16200-18-git-send-email-cheiny@synaptics.com> <CACRpkdYNUNmbMinzAth4ZBUojgTuKCvf1msuvDy3EK_3aQ9vRg@mail.gmail.com>
In-Reply-To: <CACRpkdYNUNmbMinzAth4ZBUojgTuKCvf1msuvDy3EK_3aQ9vRg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 04:01 PM, Linus Walleij wrote:
>
>> >Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>> >+#include <linux/hrtimer.h>
>> >+#include <linux/kernel.h>
>> >+#include <linux/rmi.h>
>> >+#include <linux/slab.h>
>> >+#include <linux/version.h>
>> >+#include <linux/delay.h>
> This is not using the existing in-kernel framework for ADC (which I think is
> what you're doing), in this case use the IIO subsystem so consult
> drivers/iio/adc and be inspired.
>
> Just exposing a set of weird sysfs files to userspace is not proper.

I don't think the Industrial I/O ADC framework is appropriate for this. 
  F54 isn't intended to provide access to a general purpose ADC feature, 
but rather for diagnostic access to the touchscreen's capacitive sense 
features, which results in a fairly weird (as you noticed) interface. 
Trying to hammer on it to fit into iio/adc would require a lot of 
effort, and wind up making it look like something it really isn't.

However, it makes sense to move this whole interface to debugfs, given 
its intended model of use.


