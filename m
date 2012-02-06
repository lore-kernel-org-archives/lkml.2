Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2BFEnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 23:43:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:31102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab2BFEm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 23:42:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121226662"
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
From: Lin Ming <ming.m.lin@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20120206031528.GA16093@gamma.logic.tuwien.ac.at>
References: <1328231716.15079.15.camel@minggr>
	 <1328242884.15079.22.camel@minggr>
	 <20120203052452.GC24563@gamma.logic.tuwien.ac.at>
	 <1328247269.15079.26.camel@minggr>
	 <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
	 <1328257660.15079.30.camel@minggr>
	 <20120206004608.GA9413@gamma.logic.tuwien.ac.at>
	 <1328492218.15079.38.camel@minggr>
	 <20120206024052.GI9413@gamma.logic.tuwien.ac.at>
	 <1328496591.15079.40.camel@minggr>
	 <20120206031528.GA16093@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 12:42:56 +0800
Message-ID: <1328503376.15079.55.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 12:15 +0900, Norbert Preining wrote:
> On Mo, 06 Feb 2012, Lin Ming wrote:
> > Only this patch on top of HEAD *without* reverting 7faa33da9b7.
> 
> Works. Am I right that it differs from 7faa33da9b7 only in that
> the later also changes:

Right.

Tejun,

This regression is caused by 7faa33da9b7(ahci: start engine only during
soft/hard resets).

But I can't reproduce it.

What's your guess?

Thanks,
Lin Ming

> @@ -2019,7 +2022,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
>                 ahci_power_down(ap);
>         else {
>                 ata_port_err(ap, "%s (%d)\n", emsg, rc);
> -               ata_port_freeze(ap);
> +               ahci_start_port(ap);
>         }
> 
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> HOVE (adj.)
> Descriptive of the expression seen on the face of one person in the
> presence of another who clearly isn't going to stop talking for a very
> long time.
> 			--- Douglas Adams, The Meaning of Liff


