Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086Ab2JXO4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:56:18 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:50162 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab2JXO4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:56:16 -0400
Date: Wed, 24 Oct 2012 16:56:02 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
Message-ID: <20121024165602.631f070b@skate>
In-Reply-To: <5087FD91.1050803@free-electrons.com>
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com>
	<1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com>
	<20121024142722.46c0f456@skate>
	<5087FD91.1050803@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Wed, 24 Oct 2012 16:39:13 +0200, Gregory CLEMENT wrote:

> > As others said, the prefix is wrong. Since the file is named coherency,
> > maybe just "coherency_" as the prefix? Not sure, though. Shouldn't the
> > file be named coherency-armada-370-xp.c, as we have done for the irq
> > controller file? In that case, the armada_370_xp prefix would make
> > sense
> 
> I would prefer to just use coherency_ everywhere and keep the name of
> the file as is. It made sense to suffix the irq file with
> armada-370-xp because the other mvebu SoCs have their own irq
> controller. Whereas, as far as I know the coherency unit is only
> present in the Armada 370/XP.

Well your argumentation may also be seen as an argument to name it
coherency-armada-370-xp.c :-) I don't have a strong opinion on this
though, and we can always rename it later if needed.

> >>  int armada_xp_get_cpu_count(void)
> >>  {
> >>  	int reg, cnt;
> > 
> > static?
> 
> Which function?
> armada_xp_get_cpu_count and armada_370_xp_set_cpu_coherent are exported
> and moreover are not part of this patch set but the SMP one.

Ok, then maybe this function shouldn't be between the DMA operations
implementation and the bus notifier callback.

> Yes indeed code in headsmp.S and armada_xp_smp_prepare_cpus() are
> redundant we can simplify it. I will change it in the SMP series and
> for this series also.

Great, thanks!

> > Do we have a good reason for having
> > armada_370_xp_coherency_iocache_init() separate from
> > armada_370_xp_coherency_iocache_init() ? I.e, what prevents us from
> 
> No good reason because they are the same! ;)

Oops, indeed. but I see that you fixed the problem.

> But more seriously, armada_370_xp_coherency_init() is called as an
> early_init call whereas armada_370_xp_coherency_iocache_init() is called
> later by armada_370_xp_dt_init(). I have to check if we can use
> bus_register_notifier() from an early_init call or if we still need to
> call armada_370_xp_coherency_init() as an early_init call.

The early_initcall() is mandatory, see the comment on top of it:

+/* Coherency initialization have to be done before the SMP
+ * initialization of the CPUs*/
+early_initcall(armada_370_xp_coherency_init);

(BTW, there is a missing space between CPUs and the comment terminator).

So, my point was more: is it possible to register the bus notifier
as early as inside an early_initcall() callback.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
