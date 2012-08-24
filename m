Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab2HXMWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:22:35 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:39943
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab2HXMWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:22:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bhzz1202hzz15d4Iz2dh668h839hd25he5bhf0ah11b5h1155h)
X-WSS-ID: 0M99EDD-01-6C8-02
X-M-MSG: 
Date: Fri, 24 Aug 2012 14:22:26 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/19] x86, io_apic: Introduce x86_io_apic_ops.disable()
Message-ID: <20120824122226.GW2582@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-4-git-send-email-joerg.roedel@amd.com>
 <20120823211140.GB7120@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20120823211140.GB7120@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 11:11:40PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:55:49PM +0200, Joerg Roedel wrote:
> What I miss here is the fact that you extract irq-mapping specific bits from
> disable_IO_APIC() and put them in a separate function named
> irq_remapping_disable_io_apic(). And having a big if in this function probably
> didn't look that sexy so you decided to use function op. Nice move, no
> question but not abvious from the description here and it took a while to figure
> it out based on the code. Well, maybe it is lateâ?¦

Well, yeah, the confusing thing with this patch is, that it does not only
introduce the x86_io_apic_ops.disable call-back but also adds the
infrastructure to change this op (and others). So the infrastructure
change should probably be in a seperate patch. But on the other side the
infrastructure change is small and the patch-set is already really
large.
Is it worth it to split that out?

> I don't want sound to picky here but the term 'modify' is bad I think. Would
> 'overwrite' fit better here? Is 'modify' used someplace else in x86 so you
> follow a common pattern here? Maybe it is just me.

Probably it's just me, but overwrite sounds like 'replace' (== overwrite
all ops with own values). But the code changes only a few of the ops
which need different behavior for interrupt remapping. I think 'modify'
describes that better, no?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

