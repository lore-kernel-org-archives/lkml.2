Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2ADT5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:57:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52372 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab2ADT5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:57:31 -0500
Date: Wed, 04 Jan 2012 14:56:19 -0500 (EST)
Message-Id: <20120104.145619.1728971973635198635.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, gregkh@suse.de, linux-pci@vger.kernel.org
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120104195134.GB24324@hmsreliant.think-freely.org>
References: <20120103185304.GA25184@hmsreliant.think-freely.org>
	<20120104091952.7cc5316d@jbarnes-desktop>
	<20120104195134.GB24324@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Jan 2012 11:56:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 4 Jan 2012 14:51:34 -0500

> On Wed, Jan 04, 2012 at 09:19:52AM -0800, Jesse Barnes wrote:
>> On Tue, 3 Jan 2012 13:53:05 -0500
>> Neil Horman <nhorman@tuxdriver.com> wrote:
>> 
>> > On Tue, Jan 03, 2012 at 01:05:26PM -0500, David Miller wrote:
>> > > From: Neil Horman <nhorman@tuxdriver.com>
>> > > Date: Tue,  3 Jan 2012 10:29:54 -0500
>> > > 
>> > > > This warning was recently reported to me:
>> > > 
>> > > I've hit this too, see:
>> > > 
>> > > http://marc.info/?l=linux-kernel&m=132458146927890&w=2
>> > > 
>> > > and my analysis at:
>> > > 
>> > > http://marc.info/?l=linux-arch&m=132458391128660&w=2
>> > > 
>> > Yup, your analysis is correct. Regardless of the why behind msi enablement
>> > failing, we need to gate the kobject_del/put in free_msi_irqs on successful
>> > completion of kobject_init_and_add in populate_msi_sysfs.  This patch does that,
>> > using the parent pointer as a flag.
>> 
>> I applied this to my -next branch; doesn't seem critical to land
>> immediately.  If you disagree let me know and I'll pull it over to my
>> for-linus branch instead.
>> 
>> Thanks,
> I'm ok with it waiting, but I'll defer to Dave and others who have seen it
> occur.  It sounds like its alot of log noise.

The bug only exists in the PCI -next code I thought.
