Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2ADVSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:18:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33140 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2ADVSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:18:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120104120248.4f4747bf@jbarnes-desktop>
References: <20120103185304.GA25184@hmsreliant.think-freely.org>
	<20120104091952.7cc5316d@jbarnes-desktop>
	<20120104195134.GB24324@hmsreliant.think-freely.org>
	<20120104.145619.1728971973635198635.davem@davemloft.net>
	<20120104120248.4f4747bf@jbarnes-desktop>
Date: Wed, 4 Jan 2012 16:18:49 -0500
Message-ID: <CA+5PVA4=j_pXQ0L9NBoaGGGhEWFhga_LxVG-oi11vSrm4UG3Sg@mail.gmail.com>
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
From: Josh Boyer <jwboyer@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Miller <davem@davemloft.net>, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, gregkh@suse.de,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 3:02 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 04 Jan 2012 14:56:19 -0500 (EST)
> David Miller <davem@davemloft.net> wrote:
>
>> From: Neil Horman <nhorman@tuxdriver.com>
>> Date: Wed, 4 Jan 2012 14:51:34 -0500
>>
>> > On Wed, Jan 04, 2012 at 09:19:52AM -0800, Jesse Barnes wrote:
>> >> On Tue, 3 Jan 2012 13:53:05 -0500
>> >> Neil Horman <nhorman@tuxdriver.com> wrote:
>> >>
>> >> > On Tue, Jan 03, 2012 at 01:05:26PM -0500, David Miller wrote:
>> >> > > From: Neil Horman <nhorman@tuxdriver.com>
>> >> > > Date: Tue,  3 Jan 2012 10:29:54 -0500
>> >> > >
>> >> > > > This warning was recently reported to me:
>> >> > >
>> >> > > I've hit this too, see:
>> >> > >
>> >> > > http://marc.info/?l=linux-kernel&m=132458146927890&w=2
>> >> > >
>> >> > > and my analysis at:
>> >> > >
>> >> > > http://marc.info/?l=linux-arch&m=132458391128660&w=2
>> >> > >
>> >> > Yup, your analysis is correct. Regardless of the why behind msi enablement
>> >> > failing, we need to gate the kobject_del/put in free_msi_irqs on successful
>> >> > completion of kobject_init_and_add in populate_msi_sysfs.  This patch does that,
>> >> > using the parent pointer as a flag.
>> >>
>> >> I applied this to my -next branch; doesn't seem critical to land
>> >> immediately.  If you disagree let me know and I'll pull it over to my
>> >> for-linus branch instead.
>> >>
>> >> Thanks,
>> > I'm ok with it waiting, but I'll defer to Dave and others who have seen it
>> > occur.  It sounds like its alot of log noise.
>>
>> The bug only exists in the PCI -next code I thought.
>
> Oh yeah, looks like it.  Lost track of my -next vs master branches
> there...

Er... Neil's commit log in the patch itself has an oops from 3.1.6 in
it.  If the bug the patch fixes is only present in -next PCI code, how
did it get hit on that release?

Did we switch to talking about some other patch here and I'm just confused?

josh
