Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2DQJvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:51:18 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:14743
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab2DQJvR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:51:17 -0400
X-SpamScore: -5
X-BigFish: VS-5(zz1432Nzz1202hzzz2dh2a8h668h839h8e2h8e3h944hd25hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/4] powerpc/85xx: add HOTPLUG_CPU support
Thread-Topic: [PATCH v4 1/4] powerpc/85xx: add HOTPLUG_CPU support
Thread-Index: AQHNA1X5C9oH/gR0U0uwHvF/hlzHUJaeYk6AgACR3pA=
Date: Tue, 17 Apr 2012 09:51:11 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F092D1098@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1331889732-25240-1-git-send-email-chenhui.zhao@freescale.com>
 <4F8C78B3.1070002@freescale.com>
In-Reply-To: <4F8C78B3.1070002@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  struct smp_ops_t smp_85xx_ops = {
> >  	.kick_cpu = smp_85xx_kick_cpu,
> > -#ifdef CONFIG_KEXEC
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +	.cpu_disable	= generic_cpu_disable,
> > +	.cpu_die	= generic_cpu_die,
> > +#endif
> >  	.give_timebase	= smp_generic_give_timebase,
> >  	.take_timebase	= smp_generic_take_timebase,
> > -#endif
> >  };
> 
> We need to stop using smp_generic_give/take_timebase, not expand its use.
> This stuff breaks under hypervisors where timebase can't be written.  It
> wasn't too bad before since we generally didn't enable CONFIG_KEXEC, but
> we're more likely to want CONFIG_HOTPLUG_CPU.

I understand that the guest OS shouldn't change the real timebase.  But no matter what timebase syncing method we are using, the timebase need to be changed anyway for certain features.  I think the better way should be trapping timebase modification in the hypervisor.

> 
> Do the timebase sync the way U-Boot does -- if you find the appropriate
> guts node in the device tree.

That involves stopping timebase for a short time on all cores including the cores that are still online.  Won't this be a potential issue?

- Leo 

