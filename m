Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0IXKuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:50:08 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:4976 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab0IXKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:50:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19612.33369.175358.879889@pilspetsen.it.uu.se>
Date: Fri, 24 Sep 2010 12:50:01 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [BUG 2.6.36-rc5] of_i2c.ko <-> i2c-core.ko dependency loop
In-Reply-To: <20100924111209.3c071da3@endymion.delvare>
References: <19611.16302.262307.129176@pilspetsen.it.uu.se>
	<20100923113807.4643fbbb.rdunlap@xenotime.net>
	<19611.46496.782340.466509@pilspetsen.it.uu.se>
	<20100923150559.9c67da11.rdunlap@xenotime.net>
	<20100924111209.3c071da3@endymion.delvare>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare writes:
 > On Thu, 23 Sep 2010 15:05:59 -0700, Randy Dunlap wrote:
 > > On Thu, 23 Sep 2010 22:16:32 +0200 Mikael Pettersson wrote:
 > > > Randy Dunlap writes:
 > > >  > No kconfig warnings?
 > > > 
 > > > Not that I recall.  I can check tomorrow if necessary.
 > > 
 > > No kconfig warnings.  I checked with your .config file.
 > > 
 > > >  > Please post your full .config file.
 > > 
 > > Just a matter of module i2c-core calls of_ functions and module of_i2c calls
 > > i2c_ functions.  Hmph.  Something for Grant, Jean, and Ben to work out.
 > 
 > As far as I can see this is caused by this commit from Grant:
 > 
 > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=959e85f7751c33d1a2dabc5cc3fe2ed0db7052e5
 > 
 > Mikael, can you please try reverting this patch and see if it solves
 > your problem?

Yes, reverting the above commit from 2.6.36-rc5 eliminated the warnings,
and I was able to insmod the i2c-{core,dev,powermac}.ko modules.

/Mikael
