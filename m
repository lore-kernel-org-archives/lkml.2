Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0HJRid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:38:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50500 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab0HJRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:38:27 -0400
Date: Tue, 10 Aug 2010 10:37:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-Id: <20100810103738.064b266d.randy.dunlap@oracle.com>
In-Reply-To: <20100810171343.GE21220@suse.de>
References: <4C612AA4.5040100@dsn.okisemi.com>
	<20100810171343.GE21220@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010 10:13:43 -0700 Greg KH wrote:

> On Tue, Aug 10, 2010 at 07:32:04PM +0900, Masayuki Ohtak wrote:
> > IEEE1588 driver of Topcliff PCH
> > 
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus. 
> > Topcliff PCH has IEEE1588 I/F. This driver enables IEEE1588 function on CAN or
> > Ethernet communications.
> 
> So it's a CAN or Ethernet driver?  If so, why isn't this a network
> driver like the CAN and Ethernet drivers?
> 
> > +#ifdef __GNUC__
> > +#define UNUSED __attribute__ ((unused))
> > +#define UNUSED_ARG(x)
> > +#else
> > +#define UNUSED
> > +#define UNUSED_ARG(x) (void) x
> > +#endif
> > +
> > +
> > +#define TRUE 1
> > +#define FALSE 0
> 
> These lines should not be needed at all.
> 
> > +#define IOC_1588_BASE 0xf8

and 0xf8 should be added to Documentation/ioctl/ioctl-number.txt, please.


> 
> Do you have documentation for these new ioctls you are creating?  It's a
> lot of them:
> 
> > +#define IOCTL_1588_PORT_CONFIG_SET \
> > +			_IOW(IOC_1588_BASE, 0, struct pch_portcfg_ioctl)
> > +
> > +#define IOCTL_1588_PORT_CONFIG_GET \
> > +			_IOWR(IOC_1588_BASE, 1, struct pch_portcfg_ioctl)
> > +
> > +#define IOCTL_1588_RX_POLL _IOWR(IOC_1588_BASE, 2, struct pch_rxtxpoll_ioctl)
> > +
> > +#define IOCTL_1588_TX_POLL _IOWR(IOC_1588_BASE, 3, struct pch_rxtxpoll_ioctl)
> > +
> > +#define IOCTL_1588_CAN_POLL _IOWR(IOC_1588_BASE, 4, struct pch_canpoll_ioctl)
> > +
> > +#define IOCTL_1588_SYS_TIME_GET _IOR(IOC_1588_BASE, 5, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_SYS_TIME_SET _IOW(IOC_1588_BASE, 6, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_TICK_RATE_SET _IOW(IOC_1588_BASE, 7, __u32)
> > +
> > +#define IOCTL_1588_TICK_RATE_GET _IOR(IOC_1588_BASE, 8, __u32)
> > +
> > +#define IOCTL_1588_TARG_TIME_INTRPT_ENABLE _IO(IOC_1588_BASE, 9)
> > +
> > +#define IOCTL_1588_TARG_TIME_INTRPT_DISABLE _IO(IOC_1588_BASE, 10)
> > +
> > +#define IOCTL_1588_TARG_TIME_POLL \
> > +			_IOR(IOC_1588_BASE, 11, struct pch_timepoll_ioctl)
> > +
> > +#define IOCTL_1588_TARG_TIME_SET \
> > +				_IOW(IOC_1588_BASE, 12, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_TARG_TIME_GET \
> > +				_IOR(IOC_1588_BASE, 13, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_AUX_TIME_INTRPT_ENABLE _IOW(IOC_1588_BASE, 14,\
> > +							enum pch_auxmode)
> > +
> > +#define IOCTL_1588_AUX_TIME_INTRPT_DISABLE _IOW(IOC_1588_BASE, 15,\
> > +							enum pch_auxmode)
> > +
> > +#define IOCTL_1588_AUX_TIME_POLL \
> > +			_IOWR(IOC_1588_BASE, 16, struct pch_timepoll_ioctl)
> > +
> > +#define IOCTL_1588_RESET _IO(IOC_1588_BASE, 17)
> > +
> > +#define IOCTL_1588_CHNL_RESET _IOW(IOC_1588_BASE, 18, enum pch_ptpport)
> > +
> > +#define IOCTL_1588_STATS_GET _IOR(IOC_1588_BASE, 19, struct pch_stats)
> > +
> > +#define IOCTL_1588_STATS_RESET _IO(IOC_1588_BASE, 20)
> > +
> > +#define IOCTL_1588_SHOW_ALL _IO(IOC_1588_BASE, 21)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_INTRPT_ENABLE _IO(IOC_1588_BASE, 22)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_INTRPT_DISABLE _IO(IOC_1588_BASE, 23)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_POLL \
> > +			_IOR(IOC_1588_BASE, 24, struct pch_timepoll_ioctl)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_SET \
> > +				_IOW(IOC_1588_BASE, 25, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_GET \
> > +				_IOR(IOC_1588_BASE, 26, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_PULSE_PER_SEC_INTRPT_ENABLE _IO(IOC_1588_BASE, 27)
> > +
> > +#define IOCTL_1588_PULSE_PER_SEC_INTRPT_DISABLE _IO(IOC_1588_BASE, 28)
> > +
> > +#define IOCTL_1588_TARG_TIME_NOTIFY \
> > +				_IOR(IOC_1588_BASE, 29, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_AUX_TIME_NOTIFY \
> > +			_IOR(IOC_1588_BASE, 30, struct pch_auxtimeioctl)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_NOTIFY \
> > +				_IOR(IOC_1588_BASE, 31, struct pch_tim_val)
> > +
> > +#define IOCTL_1588_PULSE_PER_SEC_NOTIFY _IOR(IOC_1588_BASE, 32, __u32)
> > +
> > +#define IOCTL_1588_TARG_TIME_CLR_NOTIFY _IO(IOC_1588_BASE, 33)
> > +
> > +#define IOCTL_1588_AUX_TIME_CLR_NOTIFY _IO(IOC_1588_BASE, 34)
> > +
> > +#define IOCTL_1588_AUX_TARG_TIME_CLR_NOTIFY _IO(IOC_1588_BASE, 35)
> > +
> > +#define IOCTL_1588_PULSE_PER_SEC_CLR_NOTIFY _IO(IOC_1588_BASE, 36)
> > +
> > +#define IOCTL_1588_PULSE_PER_SEC_TIME_GET _IOR(IOC_1588_BASE, 37, __u32)
> > +
> > +#define IOCTL_1588_PULSE_PER_SEC_TIME_SET _IOW(IOC_1588_BASE, 38, __u32)
> > +
> > +#define IOCTL_1588_PORT_VERSION_SET \
> > +			_IOW(IOC_1588_BASE, 39, struct pch_versionioctl)
> > +
> > +#define IOCTL_1588_PORT_VERSION_GET \
> > +			_IOWR(IOC_1588_BASE, 40, struct pch_versionioctl)
> > +
> > +#define IOCTL_1588_PORT_OPERATION_MODE_SET \
> > +		_IOW(IOC_1588_BASE, 41, struct pch_opemode_ioctl)
> > +
> > +#define IOCTL_1588_PORT_OPERATION_MODE_GET \
> > +		_IOWR(IOC_1588_BASE, 42, struct pch_opemode_ioctl)
> 
> Do they all have to be ioctls?  What exactly are they doing?
> 
> And are they 32/64bit safe?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
