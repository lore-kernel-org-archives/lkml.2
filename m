Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0IBTeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:34:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:16111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab0IBTeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,309,1280732400"; 
   d="scan'208";a="551147393"
Subject: Re: [PATCH v2] [arch-x86] Allow SRAT integrity check to be skipped
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1283427192.3793.100.camel@jlt3.sipsolutions.net>
References: <20100901225937.18457.16372.stgit@localhost.localdomain>
	 <1283427192.3793.100.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 12:39:00 -0700
Message-ID: <1283456340.28591.23.camel@pjaxe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 04:33 -0700, Johannes Berg wrote:
> On Wed, 2010-09-01 at 15:59 -0700, Peter P Waskiewicz Jr wrote:
> 
> > +static int srat_bypass_bios;
> > +
> > +static int __init srat_bypass_bios_setup(char *str)
> > +{
> > +        srat_bypass_bios = 1;
> > +        return 0;
> > +}
> > +early_param("sratbypassbios", srat_bypass_bios_setup);
> > +
> >  /* Use the information discovered above to actually set up the nodes. */
> >  int __init acpi_scan_nodes(unsigned long start, unsigned long end)
> >  {
> 
> I wonder, since all the things using the variable are __init, could it
> be as well? Just curious really.

That is a good question.  It makes sense to me, but I just followed what
other boot-time options did, which are not marked __init.  I'll defer to
anyone else on the list who is better-equipped to answer that.

-PJ

