Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2JFHYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:24:52 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50675 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2JFHYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:24:49 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q967NuK6021383, This message is released by code: ctaloc0852
Message-ID: <506FDC8C.3030707@realsil.com.cn>
Date: Sat, 6 Oct 2012 15:23:56 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Chris Ball <cjb@laptop.org>,
        <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Phil Turmel <philip@turmel.org>, <sameo@linux.intel.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <arnd@arndb.de>, <oakad@yahoo.com>
Subject: Re: [PATCH v6 0/3] Add modules to support realtek PCIE card reader
References: <cover.1347330871.git.wei_wang@realsil.com.cn> <50664814.30407@turmel.org> <20120929110730.GA27797@liondog.tnic> <87d315osjm.fsf@octavius.laptop.org> <20120929152942.GA11412@liondog.tnic>
In-Reply-To: <20120929152942.GA11412@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年09月29日 23:29, Borislav Petkov 写道:
> On Sat, Sep 29, 2012 at 09:41:17AM -0400, Chris Ball wrote:
>> On Sat, Sep 29 2012, Borislav Petkov wrote:
>>> So, I think that this driver has seen a bunch of testing and reviewing
>>> and we might start considering upstreaming it. There are a bunch of
>>> laptops integrating those readers and maybe a single three-month-ish -rc
>>> period of testing wouldn't hurt before it appears upstream.
>>>
>>> Now, AFAICT, there is another driver in staging which supports the same
>>> or a subset of the cardreaders this driver does so I don't know what
>>> Realsil want to do with that. Wei?
>>>
>>> And since this driver touches multiple drivers/{mfd,mmc,memstick}
>>> subdirs, maybe akpm would like to merge it? At least I haven't seen any
>>> other maintainers complaining about its design or wanting to take it so
>> I think you've missed the mails -- Alex Dubov has acked the memstick
>> portion, Samuel Ortiz has said he'll push the MFD driver for 3.7,
>> and I've pushed the MMC driver into mmc-next for 3.7.  So, I think
>> we should merge it.  I don't think we need akpm, since there are no
>> build-time dependencies involved.
> Great, all is taken care of then.
>
> Only the staging driver remains, I believe the CONFIG_RTS_PSTOR one. Wei?
>
> Thanks.
>
Hi all:

Sorry for my late reply. I'm on my vacation these days.

At first I want to explain the relationship between the staging driver 
"rts_pstor" with this one here.
Initially, we tried to build a SCSI driver for Realtek PCI-E card 
reader, which has the same architecture and code base with our Windows 
driver. And I pushed rts_pstor to staging tree last year. But Realtek 
PCI-E card reader is not a real SCSI device, which doesn't  understand 
SCSI command at all. So SCSI subsystem won't accept rts_pstor, and I 
can't find a proper subsystem to push it to.  That's why I create this 
series of drivers, which are more compatible with the whole Linux 
architecture.
We are still maintaining the SCSI driver for Realtek card reader, and 
will release the latest source code in the Github in the future.  But 
maybe we won't push it to the staging tree any more.

BR,
Wei WANG

