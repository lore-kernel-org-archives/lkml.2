Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2BOFPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:15:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57275 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2BOFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <20120213174445.GD12117@google.com>
References: <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
	<1328257660.15079.30.camel@minggr>
	<20120206004608.GA9413@gamma.logic.tuwien.ac.at>
	<1328492218.15079.38.camel@minggr>
	<20120206024052.GI9413@gamma.logic.tuwien.ac.at>
	<1328496591.15079.40.camel@minggr>
	<20120206031528.GA16093@gamma.logic.tuwien.ac.at>
	<1328503376.15079.55.camel@minggr>
	<20120206161943.GA3926@google.com>
	<CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
	<20120213174445.GD12117@google.com>
Date: Tue, 14 Feb 2012 21:15:32 -0800
Message-ID: <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, valdis.kletnieks@vt.edu,
        Mark Lord <kernel@teksavvy.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 9:44 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Feb 06, 2012 at 11:20:45AM -0800, Brian Norris wrote:
>> I see the following options:
>> (1) implement a flag that can be passed through ahci_platform; this
>> would not be very useful, as we would still have to tweak the driver
>> out of tree.
>
> Yeah, please add module param to make this behavior conditional.

Perhaps a module param (for ahci_platform) that sets a flag in
ata_port_info? I'm not sure if/how I'm allowed to introduce new ATA
flags...

>> (2) Drop the fix entirely. This is a spec. violation, but we can
>> simply try to maintain the fix out-of-tree.
>
> Nothing is perfect and real hardware should come before spec.

You have ignored my option (3): to fix the observed problems. I
already tested this last patch against the previous regression
reports, found here:
http://marc.info/?l=linux-ide&m=130529205513940&w=2

However, I had not noticed that the delayed DVD drive recognition was
a separate issue. Since then, I've noticed that I have tested the
exact same AHCI controller as Valdis' issue (a little different than
Norbert's) but the key difference is the MATSHITA DVD drive (both
Norbert and Valdis have MATSHITA). The same controller works with
non-MATSHITA DVD.

I also noticed that Mark Lord commented that he needed the patch in
question. Is this a different controller that needs my same fix?
http://marc.info/?l=linux-ide&m=131967244009803&w=2

So it appears that we are weighing the MATSHITA DVD issues against the
issues seen by me and possibly Mark Lord. If the decision really
stands that finding a unified solution is impossible, then I can just
drop the issue and make conditional behavior.

Brian
