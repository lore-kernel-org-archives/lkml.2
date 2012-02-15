Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2BOQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:57:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58824 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2BOQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:57:13 -0500
Date: Wed, 15 Feb 2012 08:57:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, valdis.kletnieks@vt.edu,
        Mark Lord <kernel@teksavvy.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
Message-ID: <20120215165706.GA24986@google.com>
References: <20120206004608.GA9413@gamma.logic.tuwien.ac.at>
 <1328492218.15079.38.camel@minggr>
 <20120206024052.GI9413@gamma.logic.tuwien.ac.at>
 <1328496591.15079.40.camel@minggr>
 <20120206031528.GA16093@gamma.logic.tuwien.ac.at>
 <1328503376.15079.55.camel@minggr>
 <20120206161943.GA3926@google.com>
 <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
 <20120213174445.GD12117@google.com>
 <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 14, 2012 at 09:15:32PM -0800, Brian Norris wrote:
> Perhaps a module param (for ahci_platform) that sets a flag in
> ata_port_info? I'm not sure if/how I'm allowed to introduce new ATA
> flags...

I think adding a module param directly to libahci.c should do.  Just
add it after ignore_sss and apply it to all ahci's on the host.

> So it appears that we are weighing the MATSHITA DVD issues against the
> issues seen by me and possibly Mark Lord. If the decision really
> stands that finding a unified solution is impossible, then I can just
> drop the issue and make conditional behavior.

My memory is already fuzzy but strict adherence to the spec didn't
make whole lot of sense to me.  I think I wrote several times on the
issue already.  Plus, we're talking about introducing regressions to
generic x86 setups against few specific platforms.  If somebody can
come up with generic solution, fine, but for now, let's just revert to
the original behavior, please.

Thanks.

-- 
tejun
