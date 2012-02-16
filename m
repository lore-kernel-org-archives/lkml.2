Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2BPQWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:22:51 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:57751 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2BPQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:22:49 -0500
Message-ID: <4F3D2D55.8000104@garzik.org>
Date: Thu, 16 Feb 2012 11:22:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Norbert Preining <preining@logic.at>,
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
References: <20120206024052.GI9413@gamma.logic.tuwien.ac.at> <1328496591.15079.40.camel@minggr> <20120206031528.GA16093@gamma.logic.tuwien.ac.at> <1328503376.15079.55.camel@minggr> <20120206161943.GA3926@google.com> <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com> <20120213174445.GD12117@google.com> <CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com> <20120215165706.GA24986@google.com> <4F3BF989.8060607@garzik.org> <20120215183139.GC24986@google.com> <4F3C04EF.7070404@garzik.org> <CAN8TOE8cuUU_Gh5gPKNWQGvunMdzDf9nLNq3GqoQuwvdnD1p8g@mail.gmail.com>
In-Reply-To: <CAN8TOE8cuUU_Gh5gPKNWQGvunMdzDf9nLNq3GqoQuwvdnD1p8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 06:39 PM, Brian Norris wrote:
> On Wed, Feb 15, 2012 at 11:18 AM, Jeff Garzik<jeff@garzik.org>  wrote:
>> On 02/15/2012 01:31 PM, Tejun Heo wrote:
>>> The problem is that there's no way to identify the controller in
>>> question, so we can't do this automatically, so might just as well do
>>> it in the simplest way for now.  :(
>>
>>
>> See ahci_devtype[] and ahci_port_info[] in ahci_platform.c for how to do
>> this.  Brian would not have to tweak the driver out of tree as claimed; we
>> put all changes in tree, and the platform calls itself "spec-strict-ahci" or
>> whatever string you prefer.
>
> OK, so can it seems I would add a flag in include/linux/libata.h that
> can be added to a new entry in ahci_port_info[]? It seems a little
> awkward to put in "libata.h", plus I'm not sure if all the flags have
> direct meaning to ATA or if they can be AHCI-specific.

Nothing needs to go into libata.h.  grep for IMX53_AHCI, and see how 
that differentiates ata_port_info information.  There you may vary 
AHCI-specific flags (defined in ahci.h), port operations, or anything 
else specific to the controller.

Create a flag, add it to ahci.h, guard the spec-strict behavior creating 
problems with said flag, and apply said flag to your controller in 
ahci_platform.

	Jeff


