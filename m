Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0G2Itz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:49:55 -0400
Received: from www.tglx.de ([62.245.132.106]:49198 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab0G2Itv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:49:51 -0400
Date: Thu, 29 Jul 2010 10:49:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <ian.campbell@citrix.com>
cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        xen-devel@lists.xensource.com, linux-input@vger.kernel.org,
        linuxppc-dev@ozlabs.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/4] irq: rename IRQF_TIMER to IRQF_NO_SUSPEND
In-Reply-To: <1280314467-5637-1-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.LFD.2.00.1007291045060.2471@localhost.localdomain>
References: <1280314445.24292.90.camel@zakaz.uk.xensource.com> <1280314467-5637-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010, Ian Campbell wrote:

> Continue to provide IRQF_TIMER as an alias to IRQF_NO_SUSPEND since I
> think it is worth preserving the nice self-documenting name (where it
> is used appropriately). It also avoid needing to patch all the many
> users who are using the flag for an actual timer interrupt.

I'm not happy about the alias. What about:

#define __IRQF_TIMER		0x00000200
#define IRQF_NO_SUSPEND		0x00000400

#define IRQF_TIMER    (__IRQF_TIMER | IRQF_NO_SUSPEND)

Thanks,

	tglx
