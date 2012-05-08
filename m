Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab2EHAx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:53:56 -0400
Received: from relay.ihostexchange.net ([66.46.182.56]:14720 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2EHAxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:53:55 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ingo Molnar <mingo@kernel.org>, Ido Yariv <ido@wizery.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Date: Mon, 7 May 2012 20:53:53 -0400
Subject: RE: [PATCH v2 2/2] vsmp: Ignore IOAPIC IRQ affinity if possible
Thread-Topic: [PATCH v2 2/2] vsmp: Ignore IOAPIC IRQ affinity if possible
Thread-Index: Ac0sVBVKXBvHOQI9SC+oGmsODMrisQAXzdig
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317D0A62A08B@VMBX108.ihostexchange.net>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
 <1334561976-13965-1-git-send-email-ido@wizery.com>
 <1334561976-13965-2-git-send-email-ido@wizery.com>
 <20120507131943.GI23858@gmail.com>
In-Reply-To: <20120507131943.GI23858@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo.kernel.org@gmail.com> wrote:
> * Ido Yariv <ido@wizery.com> wrote:

> > @@ -51,6 +60,7 @@ void __init default_setup_apic_routing(void)
> >  	if (is_vsmp_box()) {
> >  		/* need to update phys_pkg_id */
> >  		apic->phys_pkg_id = apicid_phys_pkg_id;
> > +		apic->vector_allocation_domain =
> fill_vector_allocation_domain;
> >  	}
> >  }
> 
> This is_vsmp_box() special case should really move into its own
> apic handler.
> 
> Thanks,

Ingo,

vSMP Foundation virtualize multiple systems as one.  The Guest OS is using the underlying hardware APIC driver, and therefore we must allow the various APIC drivers to kick in.  When using vSMP Foundation APIC driver is selected by the kernel based on the hardware that is being virtualized, and that can be APIC, X2APIC phys, X2APIC cluster, summit, etc.

If we would to implement an APIC handler, we would not be able to use the native hardware APIC driver (unless we do an ugly hack).  

The above optimization applies to all APIC drivers.  It allow vSMP Foundation to route interrupts to the "closest" processor.  For this we need to override the vector_allocation_domain of any APIC that selected (as noted, selection depends on real HW).  

I hope this will allow you to ack our approach.

Regards,
Shai.
