Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2CIAGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:06:30 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60006 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2CIAG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:06:28 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+oEIZzUr/dL2SRd4dUMRE7
Date: Thu, 8 Mar 2012 16:06:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Russ Dill <Russ.Dill@ti.com>, balbi@ti.com, Matt Porter <mporter@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120309000621.GA12083@atomide.com>
References: <1330006564-13290-1-git-send-email-mporter@ti.com>
 <87wr74gis6.fsf@ti.com>
 <20120301204553.GA21841@legolas.emea.dhcp.ti.com>
 <87pqcqnc7u.fsf@ti.com>
 <CA+Bv8XaJqL1L8F-n6skY7dHn1XAdDLRKaRjw0deLeoQ5Ao0Fhg@mail.gmail.com>
 <87sjhkjj8m.fsf@ti.com>
 <20120308210825.GY12083@atomide.com>
 <87y5raaiob.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5raaiob.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@ti.com> [120308 12:54]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> > * Kevin Hilman <khilman@ti.com> [120307 11:05]:
> >> >
> >> > I don't think the second smsc911x on the Overo, "smsc911x.1", would
> >> > find it due to the dev_id.
> >> 
> >> It's not about finding the second regulator.  As stated in the
> >> changelog, it's about the duplicate attempt to register the exact same
> >> platform_device.
> >> 
> >> Duplicate attempts to register the exact same platform_device cause
> >> kobject to panic and give up[1].  So, any platform that calls
> >> gpmc_smsc911x_init() twice (Overo and T35 in mainline) will panic on
> >> boot.
> >> 
> >> This patch fixes those platforms so they can boot.
> >
> > Yeah but I guess the second smsc911x instance still would not work,
> > or am I missing something?
> 
> I don't know since my Overo expansion boards don't have a 2nd NIC, but I
> suspect you're right.
> 
> However, my fix isn't addressing that.  I am fixing a problem where
> mainline today will panic on some boards due to duplicate registration.
> 
> If the 2nd interface doesn't work, then the original patch that added
> the regulators needs a rethink.  My patch to prevent the panic() is
> needed for mainline.

With Kevin's second version of this patch applied we avoid the panic
on boards with more than one smsc911x.

After this patch, board-*.c files can add custom regulators for their
other smsc911x instances.

We should also add a regulator to the struct omap_smsc911x_platform_data,
and then only initialize the fixed regulator automatically
if (!board_data->regulator && !board_data->id).

So I've pushed Kevin's second version of the fix to fix-smsc911x-regulator
branch.

Regards,

Tony
