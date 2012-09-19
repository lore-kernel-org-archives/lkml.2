Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2ISOya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:54:30 -0400
Received: from [216.32.180.187] ([216.32.180.187]:52829 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab2ISOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:54:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Id6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MALQNF-02-D94-02
X-M-MSG: 
Date: Wed, 19 Sep 2012 16:52:27 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 00/19 v2] Improve IRQ remapping abstraction in x86 core
 code
Message-ID: <20120919145227.GS2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <20120826191749.GK3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826191749.GK3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

finally I am back from vacation and resume work on this :)

On Sun, Aug 26, 2012 at 09:17:49PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:55:46PM +0200, Joerg Roedel wrote:
> > Please review.
> 
> Finally. Usually you don't add/change code but you just move common
> irq remapping pieces out of geric io-apic code and put them in once place. I
> think it would be good, if you would note this in the description of your
> patch.
> Altogether it makes a good impression.

Thanks, and thanks for your review.

> After browsing through the new functions in irq_remapping_modify_x86_ops() I
> see that some of them test for "remap_ops" which is pointless because you don't
> call irq_remapping_modify_x86_ops() if it is not the case. This also goes mostly
> for irq_remapping_enabled.

Okay, I am usually a bit conservative when it comes to checking function
pointers and conditions. One reason is that the Linux kernel had severe
security bugs in the past with NULL functions pointers being called.
Especially when future changes modify the code path these function
pointers it is easy to forget re-adding the checks. But I will look
again at the patches to check which checks can be removed and which
should better stay.

> The only reason when you can disable (or say irq_remapping_disable() is
> called) is in the suspend path. And the remap is enabled again in via
> irq_remapping_reenable() in resume. Now if this goes wrong what is next? You
> don't even return an error if the callback is missing. The variable
> irq_remapping_enabled does not save your ass here because some function
> behave now different.
> 
> But back to the realisitic world: If something goes wrong in resume and you
> can't re-enable irq remapping, the system is not really useable or is it (even
> before your series)?

Well, when something goes wrong on resume and irq-remapping doesn't work
anymore the system is usually doomed (with and without this patch-set).
When irq-remapping does not work the dma-remapping will likely also not
work anymore which is even worse.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

