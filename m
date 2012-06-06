Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2FFKS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:18:27 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:35295
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab2FFKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:18:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 6 Jun 2012 18:19:03 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 5/5] powerpc/85xx: add support to JOG feature using
 cpufreq interface
Message-ID: <20120606101903.GC23505@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-5-git-send-email-chenhui.zhao@freescale.com>
 <4FC950AF.90007@freescale.com>
 <20120605105929.GA22427@localhost.localdomain>
 <4FCE2CB1.5090308@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FCE2CB1.5090308@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 10:58:41AM -0500, Scott Wood wrote:
> On 06/05/2012 05:59 AM, Zhao Chenhui wrote:
> > On Fri, Jun 01, 2012 at 06:30:55PM -0500, Scott Wood wrote:
> >> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> >>> The jog mode frequency transition process on the MPC8536 is similar to
> >>> the deep sleep process. The driver need save the CPU state and restore
> >>> it after CPU warm reset.
> >>>
> >>> Note:
> >>>  * The I/O peripherals such as PCIe and eTSEC may lose packets during
> >>>    the jog mode frequency transition.
> >>
> >> That might be acceptable for eTSEC, but it is not acceptable to lose
> >> anything on PCIe.  Especially not if you're going to make this "default y".
> > 
> > It is a hardware limitation.
> 
> Then make sure jog isn't used if PCIe is used.
> 
> Maybe you could do something with the suspend infrastructure, but this
> is sufficiently heavyweight that transitions should be manually
> requested, not triggered by the automatic cpufreq governor.
> 
> Does this apply to p1022, or just mpc8536?

Both of them.

> 
> > Peripherals in the platform will not be operating
> > during the jog mode frequency transition process.
> 
> What ensures this?
> 
> -Scott

Hardware ensures it without software intervention.

-Chenhui

