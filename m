Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0JVQv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:51:59 -0400
Received: from mxout1.idt.com ([157.165.5.25]:36477 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0JVQv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:51:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Date: Fri, 22 Oct 2010 09:47:46 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4CC0AD74.8070800@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Thread-Index: ActxZTVhIAwPi3XwSPaaiCn7hjV7oAAjVM7A
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen <micha@neli.hopto.org> wrote:
> 
> Alexandre Bounine wrote:
> > 1. Using one storage location common for switches and endpoints
eliminates
> > unnecessary device type checks during maintenance access operations.
> > While destination IDs and hop counts have different meaning for
endpoints and
> > switches, this does not prevent us from storing them in the primary
RIO device
> > structure (rio_dev) for both types.
> 
> How can you say this? The two variables have different meanings, this
> logically implies you can't merge them. So how do you say 'this does
not
> prevent us from ...' without providing a reason?

Looks like I formulated it bad - better would be: they have different
interpretation by hardware but logically in RapidIO they have single
role - destid/hopcount are a device coordinates in the RIO network used
to access that device.

> > 2. Convert RIO switch device structures (rio_dev + rio_switch) into
single
> > allocation unit. This change is based on the fact that RIO switches
are using
> > common RIO device objects anyway. Allocating RIO switch objects as
RIO devices
> > with added space for switch information simplifies handling of RIO
switch device
> > objects.
> 
> I still don't think that's a good idea because the rdev->rswitch
pointer
> can be defined to point to the switch that a given rio_dev is
connected
> to. This is useful for quick lookups. How else can to know to which
> switch a given device is connected?

rdev->rswitch is not a pointer to the entire switch device object - it
is a pointer to the switch specific extension associated with given
rio_dev (if applicable). There is no other role for rdev->rswitch.

Why would you keep a pointer to device data extension instead of the
pointer to attached device object itself?

BTW, I have back and forward links added in previous patches and only
one link that may be added later is a forward link from mport to the
attached rio_dev (ptr to rio_switch will not work here because it can be
switchless connection). But this reference has to be added into
rio_mport.
 
Alex.

