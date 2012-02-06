Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2BFTUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:20:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39277 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab2BFTUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120206161943.GA3926@google.com>
References: <20120203052452.GC24563@gamma.logic.tuwien.ac.at>
	<1328247269.15079.26.camel@minggr>
	<20120203054319.GA25510@gamma.logic.tuwien.ac.at>
	<1328257660.15079.30.camel@minggr>
	<20120206004608.GA9413@gamma.logic.tuwien.ac.at>
	<1328492218.15079.38.camel@minggr>
	<20120206024052.GI9413@gamma.logic.tuwien.ac.at>
	<1328496591.15079.40.camel@minggr>
	<20120206031528.GA16093@gamma.logic.tuwien.ac.at>
	<1328503376.15079.55.camel@minggr>
	<20120206161943.GA3926@google.com>
Date: Mon, 6 Feb 2012 11:20:45 -0800
Message-ID: <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
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
        Kevin Cernekee <cernekee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 8:19 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> (cc'ing Jian Peng, hi)

Hello,

Jian Peng is no longer working on this project; I have taken over for his work.

> On Mon, Feb 06, 2012 at 12:42:56PM +0800, Lin Ming wrote:
>> On Mon, 2012-02-06 at 12:15 +0900, Norbert Preining wrote:
>> > On Mo, 06 Feb 2012, Lin Ming wrote:
>> > > Only this patch on top of HEAD *without* reverting 7faa33da9b7.
>> >
>> > Works. Am I right that it differs from 7faa33da9b7 only in that
>> > the later also changes:
>>
>> Right.
>>
>> Tejun,
>>
>> This regression is caused by 7faa33da9b7(ahci: start engine only during
>> soft/hard resets).
>>
>> But I can't reproduce it.
>>
>> What's your guess?
>
> Urgh.... yeah, following standard can sometimes be silly thing to do.
> Jian, I think we'll have to add a flag for your controller and revert
> to the original behavior for others.  How can your controller be
> distinguished?

Our controller utilizes the ahci_platform.c driver and does not have a
distinguishing interface ID (e.g., PCI ID). It is maintained in an
out-of-tree distribution, but we would like to have a
standards-compliant solution in mainline so that we do not have to
support a fork of the main codebase.

Is there any possibility of debugging this regression instead of
effectively reverting it for mainline? Or perhaps can I have better
information regarding the hardware on which this regression is seen?
With some time, I can try to debug it further.

I see the following options:
(1) implement a flag that can be passed through ahci_platform; this
would not be very useful, as we would still have to tweak the driver
out of tree.
(2) Drop the fix entirely. This is a spec. violation, but we can
simply try to maintain the fix out-of-tree.
(3) Debug Norbert's hardware problems.

(1) or (2) aren't ideal, and they are effectively very similar. The
only advantage to (1) is that there will be at least some illusion of
our controller's support in future kernel development.

Brian
