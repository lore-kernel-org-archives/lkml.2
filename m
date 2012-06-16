Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2FPCui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 22:50:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:44461 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab2FPCuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 22:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166333285"
Date: Sat, 16 Jun 2012 10:50:31 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Reducing the noise level of build error notifications to 0
Message-ID: <20120616025031.GA8182@localhost>
References: <4fdbcd2f.Ta8kRp58FRzqrqaL%wfg@linux.intel.com>
 <20120616011646.GA7847@localhost>
 <20120616014732.GA2981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616014732.GA2981@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[switch to LKML]

On Fri, Jun 15, 2012 at 06:47:32PM -0700, Greg Kroah-Hartman wrote:
> On Sat, Jun 16, 2012 at 09:16:46AM +0800, Fengguang Wu wrote:
> > Hi list,
> > 
> > I'm sorry if this pile of build errors disturbed you too much. If
> > the error notification is too permissive, I can limit it in two ways:
> > 
> > 1) only notify build errors on the first kconfig. There may be a few
> >    new error messages show up in the other kconfig builds, however
> >    mostly are just irritating duplications.
> 
> Duplicates should be suppressed, they are just annoying.

OK!  I'll suppress noises in four ways:

rule 1: all newly shown-up error messages will be only notified for
        the current commit and remembered to be "known bug" thereafter.

rule 2: when one bad commit triggers build errors in multiple kconfigs,
        only one of them will be CCed. The patch author will still get
        full information in private emails.

rule 3: when one bad commit triggers build errors in the _subsequent_
        innocent commits of the same branch, the emails will be sent
        to myself for manual check first. This will inevitably lead to
        more delays (esp. when I'm sleeping), however 2+ bad commits
        should not happen frequently.

rule 4: gcc/sparse warnings will never be CCed. Only private email
        notifications will be sent to the author.

The above rules should be able to reduce the noise level close to 0
for maintainers and public mailing lists.

The commit author may still see some noises, however the good thing
is, he should be able to tell signals from noises much easier than
the others.

> > 2) only notify the mailing list directly associated with the git tree.
> >    In this particular case, to only CC devel@driverdev.osuosl.org, and
> >    to avoid the linux-mtd and linuxppc-dev lists.
> 
> Yes, that would be the best thing to do to start with, then let the
> developers take it from there.

Good point!  The developers knows best who to CC :)

Thanks,
Fengguang
