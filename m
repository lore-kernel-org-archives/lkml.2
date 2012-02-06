Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2BFDPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 22:15:40 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57004 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2BFDPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 22:15:37 -0500
Date: Mon, 6 Feb 2012 12:15:29 +0900
From: Norbert Preining <preining@logic.at>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
	COMRESET failed
Message-ID: <20120206031528.GA16093@gamma.logic.tuwien.ac.at>
References: <1328231716.15079.15.camel@minggr> <1328242884.15079.22.camel@minggr> <20120203052452.GC24563@gamma.logic.tuwien.ac.at> <1328247269.15079.26.camel@minggr> <20120203054319.GA25510@gamma.logic.tuwien.ac.at> <1328257660.15079.30.camel@minggr> <20120206004608.GA9413@gamma.logic.tuwien.ac.at> <1328492218.15079.38.camel@minggr> <20120206024052.GI9413@gamma.logic.tuwien.ac.at> <1328496591.15079.40.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328496591.15079.40.camel@minggr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 06 Feb 2012, Lin Ming wrote:
> Only this patch on top of HEAD *without* reverting 7faa33da9b7.

Works. Am I right that it differs from 7faa33da9b7 only in that
the later also changes:
@@ -2019,7 +2022,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
                ahci_power_down(ap);
        else {
                ata_port_err(ap, "%s (%d)\n", emsg, rc);
-               ata_port_freeze(ap);
+               ahci_start_port(ap);
        }


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HOVE (adj.)
Descriptive of the expression seen on the face of one person in the
presence of another who clearly isn't going to stop talking for a very
long time.
			--- Douglas Adams, The Meaning of Liff
