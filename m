Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab0G2JDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:03:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61501 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0G2JDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:03:39 -0400
X-IronPort-AV: E=Sophos;i="4.55,279,1278302400"; 
   d="scan'208";a="9561677"
Subject: Re: [PATCH 1/4] irq: rename IRQF_TIMER to IRQF_NO_SUSPEND
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <alpine.LFD.2.00.1007291045060.2471@localhost.localdomain>
References: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
	 <1280314467-5637-1-git-send-email-ian.campbell@citrix.com>
	 <alpine.LFD.2.00.1007291045060.2471@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 29 Jul 2010 10:03:34 +0100
Message-ID: <1280394214.24292.1594.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 09:49 +0100, Thomas Gleixner wrote:
> On Wed, 28 Jul 2010, Ian Campbell wrote:
> 
> > Continue to provide IRQF_TIMER as an alias to IRQF_NO_SUSPEND since I
> > think it is worth preserving the nice self-documenting name (where it
> > is used appropriately). It also avoid needing to patch all the many
> > users who are using the flag for an actual timer interrupt.
> 
> I'm not happy about the alias. What about:
> 
> #define __IRQF_TIMER		0x00000200
> #define IRQF_NO_SUSPEND		0x00000400
> 
> #define IRQF_TIMER    (__IRQF_TIMER | IRQF_NO_SUSPEND)

Sure, I'll rework along those lines.

Ian.



