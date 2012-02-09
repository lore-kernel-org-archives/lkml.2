Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2BIPuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:50:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49261 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752828Ab2BIPuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:50:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/XM9oPo6PXn4eUookTAlXkQMlJ1JkGH5a9ERx08e
	k0ItQy8EflIgKi
Message-ID: <1328802608.13577.8.camel@marge.simpson.net>
Subject: Re: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com, eranian@google.com, linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 16:50:08 +0100
In-Reply-To: <20120209133101.GC8830@elte.hu>
References: <20120207145535.71b9f22d@kryten>
	 <20120207144033.GB2172@infradead.org>
	 <1328782223.9303.3.camel@marge.simpson.net> <20120209133101.GC8830@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 14:31 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2012-02-07 at 12:40 -0200, Arnaldo Carvalho de Melo wrote: 
> > > Em Tue, Feb 07, 2012 at 02:55:35PM +1100, Anton Blanchard escreveu:
> > > > 
> > > > A perf annotate of a kernel function written in assembly shows
> > > > very strange percentages:
> > > 
> > > Thanks! I think this is the same problem Mike Galbraith noticed and
> > > reported me (I guess that was in a private message), Mike, can you
> > > please test it so that I can add more Foo-by stamps to this one?
> > 
> > Sorry for the slow response (bz bz).
> > 
> > I don't see that problem, but perf top annotation isn't 
> > working properly in tip at least.  It seems to have forgotten 
> > how to average, seems to be clearing hit counts at every 
> > screen refresh or something.
> 
> hm, seems to work fine here. We used to have such a bug recently 
> (as of a few weeks [days?] ago), but latest -tip does not show 
> those symptoms.

Build dependency buglet snuck into tip config, but annotating master
v3.3-rc3-0-gd65b4e9 with tips patched perf worked fine.

Tested-by: Mike Galbraith <efault@gmx.de>


marge:/usr/local/src/kernel/linux-3.x-tip # make -j4
scripts/kconfig/conf --silentoldconfig Kconfig
warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
make[1]: Nothing to be done for `all'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  GZIP    kernel/config_data.gz
  CHK     kernel/config_data.h
  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#2077)
  MODPOST 611 modules
ERROR: "uwb_rsv_establish" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_pal_register" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_get_usable_mas" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_destroy" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_radio_stop" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_terminate" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_pal_unregister" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_pal_init" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rc_reset_all" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_radio_start" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_create" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rc_put" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "uwb_rc_get_by_grandpa" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "__umc_driver_register" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "umc_driver_unregister" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "whci_wait_for" [drivers/usb/host/whci/whci-hcd.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
marge:/usr/local/src/kernel/linux-3.x-tip # git describe
v3.3-rc2-1377-gf4ab688


