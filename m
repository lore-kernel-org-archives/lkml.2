Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab2BPOaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:30:01 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:54790 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458Ab2BPO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:29:59 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Feb 2012 09:29:58 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqkBAGwQPU8Y9geI/2dsb2JhbAAMLgqFEakGhUMBAQEBAyMEUQEQCw4KAgIFFgsCAgkDAgECAUUGDQEHAQGvG5FdgS+IBII/BCwBAQYGCAIDBQQCAgoBCgMDAwKDXwYIBQsJAQEDAYI3gRYEiE6fbw
X-IronPort-AV: E=Sophos;i="4.73,429,1325480400"; 
   d="scan'208";a="163316805"
Message-ID: <4F3D10A6.8090608@teksavvy.com>
Date: Thu, 16 Feb 2012 09:20:22 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, valdis.kletnieks@vt.edu
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET
 failed
References: <20120206024052.GI9413@gamma.logic.tuwien.ac.at> <1328496591.15079.40.camel@minggr> <20120206031528.GA16093@gamma.logic.tuwien.ac.at> <1328503376.15079.55.camel@minggr> <20120206161943.GA3926@google.com> <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com> <20120213174445.GD12117@google.com> <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com> <20120215165706.GA24986@google.com> <4F3BF989.8060607@garzik.org> <20120215183139.GC24986@google.com>
In-Reply-To: <20120215183139.GC24986@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-15 01:31 PM, Tejun Heo wrote:
> Hey, Jeff.
> 
> On Wed, Feb 15, 2012 at 01:29:29PM -0500, Jeff Garzik wrote:
>> A module parameter is not necessarily the best/only option.
>> ahci_platform already has infrastructure set up to deal with
>> platform-specific quirks.  An internal flag seems more appropriate
>> to enable automatic handling of this on the specific platforms where
>> it applies (plus the revert Tejun has already mentioned).
> 
> The problem is that there's no way to identify the controller in
> question, so we can't do this automatically, so might just as well do
> it in the simplest way for now.  :(

Well, a module parameter is no good,
because that method would affect all attached controllers
rather than just the one(s) with the issue.

Something in sysfs perhaps.
