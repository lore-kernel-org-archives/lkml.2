Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2IYPJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:09:15 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:27476
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab2IYPJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:09:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWVF4-02-M8H-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 17:09:05 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 18/19] x86, io_apic: Introduce eoi_ioapic_pin call-back
Message-ID: <20120925150905.GD2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-19-git-send-email-joerg.roedel@amd.com>
 <20120826185233.GJ3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826185233.GJ3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 08:52:33PM +0200, Sebastian Andrzej Siewior wrote:
> Basically you shuffle the code from up there, down there and call from behind
> a function pointer. There are two things different this time:
> - no version check >= 0x20
>   I belive this is obsolete since this runs only on x86-64 with x(2)apic
>   support and assumes more or less version 0x20+ or we wouldn't be here at
>   all.

Right, all systems that have interrupt remapping have an io-apic version
of 0x20 or higher.

> - the irq_remapped(cfg) check is gone. The cfg thing is per-interrupt basis
>   created so you _now_ you act like the interrupt is remapped even if it is
>   not. Or am I wrong here?

That comes from the fact that with the current implementation (with and
without my patches) IO-APIC interrupts are always remapped. So it is
safe to remove that check.

> > +
> New line and the end? Why would that be?

Coding leftover, I'll remove that.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

