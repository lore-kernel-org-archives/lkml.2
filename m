Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2CMOeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:34:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37330 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2CMOei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:34:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAFawwkVuCTijwLr6UWVRh9XNGCt-8brr2f4aDrpM_YwkWSGP+A@mail.gmail.com>
References: <CAFawwkXQhyj+c8LEDnD7q4mXDJV2jYCAHV0tBrqxrEaNGk+_0w@mail.gmail.com>
 <CACNz9cVbULxVSGvo60V+JLL=15BDEaYwgd5k9ZMNu09Kfwz4WQ@mail.gmail.com>
 <CAFawwkWQd=y=kVm97UjSs37=-MRmJiy9f7sy8ChYzCHZ9Y-gyA@mail.gmail.com> <CAFawwkVuCTijwLr6UWVRh9XNGCt-8brr2f4aDrpM_YwkWSGP+A@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 13 Mar 2012 22:34:18 +0800
Message-ID: <CAGsJ_4yDjDLSPwXubcecmCzpeJTwvGz30-awSAZfC+YtTwB_-w@mail.gmail.com>
Subject: Re: implementing "suspend to ram" on cortex A8 based on linux 3.0.8
To: yang gqyang <hustgqyang@gmail.com>
Cc: Chenglie He <chengjie.he@linaro.org>, Robert Lee <rob.lee@linaro.org>,
        nicolas.pitre@linaro.org, venki@google.com,
        linaro-dev@lists.linaro.org, linux-sh@vger.kernel.org,
        tony@atomide.com, linux@arm.linux.org.uk, ccross@google.com,
        kernel@wantstofly.org, khilman@ti.com, kgene.kim@samsung.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, jon-hunter@ti.com,
        len.brown@intel.com, patches@linaro.org, nsekhar@ti.com, rjw@sisk.pl,
        Baohua.Song@csr.com, linux-omap@vger.kernel.org, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, linux-pm@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi yang,

在 2012年3月10日 下午10:37，yang gqyang <hustgqyang@gmail.com> 写道：
>  Thanks for your comment.
>  Finally, i find out that i made a mistake.  The uart(8250) have not been
>  restore after resume, instead, it use the configuration got from boot. The
>  uart have not been restored correctly, so that "ls" can not output result
>  correctly resulting in it seems that the busybox can not work correctly.
>  Now, i still have a question about the uart: why the "printk" can work
>  correctly, but the "printf" not?
>
>  Before this, i believe that the "printk" work correctly, then the uart
>  work ok. but now, i  need more reconsidaration about
>  the relation between the "printk", "printf" and "uart".
>  Can anyone give me some suggestion? Any comment is welcome, thanks a
>  lot.

printk use "struct console" driver, it doesn't depend on a device node
for userspace.
printf actaully depends on uart_driver and a /dev/ttySx device node,
stdout and stderr are redirected to /dev/ttySx
uart is just a hardware which can be a tty or kernel console output.


>
>
-barry
