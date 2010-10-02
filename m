Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0JBAE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 20:04:59 -0400
Received: from imr3.ericy.com ([198.24.6.13]:48883 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0JBAE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 20:04:58 -0400
Date: Fri, 1 Oct 2010 17:03:48 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Yuri Kululin <ext-yuri.kululin@nokia.com>
CC: Yuri Ershov <ext-yuri.ershov@nokia.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "samu.p.onkalo@nokia.com" <samu.p.onkalo@nokia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "daniel@caiaq.de" <daniel@caiaq.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [1/2] lis3: Add device owner
Message-ID: <20101002000348.GB25276@ericsson.com>
References: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
 <20100924202404.GA20813@ericsson.com>
 <4CA1ACC3.4000809@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CA1ACC3.4000809@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:52:19AM -0400, Yuri Kululin wrote:
[ ... ]
> 
> > On a higher level, reassigning the owner like this seems to be quite uncommon,
> > at least in hwmon. I would like to see an Acked-by from Eric to ensure
> > that the fix is correct.
> 
> I tried to use the standard way of module usage control because all functions 
> provided by lis3lv02d_i2c.c, lis3lv02d_spi.c or hp_accel.c can be called through 
>   lis3lv02d_misc_fops file ops or joystick poll device.
> 
> I can propose another solution. We can use try_module_get(owner) during device 
> registration (in lis3lv02d_add_fs()), release module by using module_put(owner) 
>   after device unregister (in lis3lv02d_remove_fs()) and do not touch 
> lis3lv02d_misc_fops. But anyway dev->owner should be set.
> 
Key is really to get feedback from others, since I am neither familiar
with module ownership handling nor with this driver.

Thanks,
Guenter
