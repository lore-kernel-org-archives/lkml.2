Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2BOXjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:39:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60840 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab2BOXjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:39:09 -0500
MIME-Version: 1.0
In-Reply-To: <4F3C04EF.7070404@garzik.org>
References: <20120206024052.GI9413@gamma.logic.tuwien.ac.at>
	<1328496591.15079.40.camel@minggr>
	<20120206031528.GA16093@gamma.logic.tuwien.ac.at>
	<1328503376.15079.55.camel@minggr>
	<20120206161943.GA3926@google.com>
	<CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
	<20120213174445.GD12117@google.com>
	<CAN8TOE-hFvDs4mGeYVRBDyfbyg8t_7YXDintLeG1QHvMXhVh+A@mail.gmail.com>
	<20120215165706.GA24986@google.com>
	<4F3BF989.8060607@garzik.org>
	<20120215183139.GC24986@google.com>
	<4F3C04EF.7070404@garzik.org>
Date: Wed, 15 Feb 2012 15:39:08 -0800
Message-ID: <CAN8TOE8cuUU_Gh5gPKNWQGvunMdzDf9nLNq3GqoQuwvdnD1p8g@mail.gmail.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, valdis.kletnieks@vt.edu,
        Mark Lord <kernel@teksavvy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 11:18 AM, Jeff Garzik <jeff@garzik.org> wrote:
> On 02/15/2012 01:31 PM, Tejun Heo wrote:
>> The problem is that there's no way to identify the controller in
>> question, so we can't do this automatically, so might just as well do
>> it in the simplest way for now.  :(
>
>
> See ahci_devtype[] and ahci_port_info[] in ahci_platform.c for how to do
> this.  Brian would not have to tweak the driver out of tree as claimed; we
> put all changes in tree, and the platform calls itself "spec-strict-ahci" or
> whatever string you prefer.

OK, so can it seems I would add a flag in include/linux/libata.h that
can be added to a new entry in ahci_port_info[]? It seems a little
awkward to put in "libata.h", plus I'm not sure if all the flags have
direct meaning to ATA or if they can be AHCI-specific.

Brian
