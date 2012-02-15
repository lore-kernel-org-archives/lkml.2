Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2BOS3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:29:35 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:36830 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2BOS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:29:33 -0500
Message-ID: <4F3BF989.8060607@garzik.org>
Date: Wed, 15 Feb 2012 13:29:29 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, valdis.kletnieks@vt.edu,
        Mark Lord <kernel@teksavvy.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET
 failed
References: <20120206004608.GA9413@gamma.logic.tuwien.ac.at> <1328492218.15079.38.camel@minggr> <20120206024052.GI9413@gamma.logic.tuwien.ac.at> <1328496591.15079.40.camel@minggr> <20120206031528.GA16093@gamma.logic.tuwien.ac.at> <1328503376.15079.55.camel@minggr> <20120206161943.GA3926@google.com> <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com> <20120213174445.GD12117@google.com> <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com> <20120215165706.GA24986@google.com>
In-Reply-To: <20120215165706.GA24986@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 11:57 AM, Tejun Heo wrote:
> Hello,
>
> On Tue, Feb 14, 2012 at 09:15:32PM -0800, Brian Norris wrote:
>> Perhaps a module param (for ahci_platform) that sets a flag in
>> ata_port_info? I'm not sure if/how I'm allowed to introduce new ATA
>> flags...
>
> I think adding a module param directly to libahci.c should do.  Just
> add it after ignore_sss and apply it to all ahci's on the host.

A module parameter is not necessarily the best/only option. 
ahci_platform already has infrastructure set up to deal with 
platform-specific quirks.  An internal flag seems more appropriate to 
enable automatic handling of this on the specific platforms where it 
applies (plus the revert Tejun has already mentioned).

Nothing wrong with debugging the regression further (Brian's option #3), 
but in the meantime we need to be actively using the best known working 
state, which means making the "fix" opt-in rather than unconditional or 
opt-out.

	Jeff





