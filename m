Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2BTOWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:22:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56639 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab2BTOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:22:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of monstr@monstr.eu designates 10.204.143.145 as permitted sender) smtp.mail=monstr@monstr.eu
Message-ID: <4F425711.80102@monstr.eu>
Date: Mon, 20 Feb 2012 15:22:09 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com> <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com> <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com> <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com> <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com> <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu> <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com> <4F3CFFAD.9030402@monstr.eu> <4F3D032B.6090700@monstr.eu> <CAK=WgbZ3oXc+NQscdShqmu2wkzv=M-qBDCH2-k=5qSRX9W=z3Q@mail.gmail.com> <CAHTX3dJ4PruKO-wJLJU8W0boHFL0f6eoF+QNaoNjm5hu26YEow@mail.gmail.com> <CAK=WgbZBJJbFcoeZ+hY=BgyW_4yvOJPVNMZ18_9o+zY7tEc_pQ@mail.gmail.com>
In-Reply-To: <CAK=WgbZBJJbFcoeZ+hY=BgyW_4yvOJPVNMZ18_9o+zY7tEc_pQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen wrote:
> On Thu, Feb 16, 2012 at 9:21 PM, Michal Simek <monstr@monstr.eu> wrote:
>> IRC in init part Linux kick rtos which send which services are available.in
>> any format which is unknown to me.
> 
> Check out struct rpmsg_ns_msg - that's the exact format of the name
> service notification messages (it's also mentioned by
> Documentation/rpmsg.txt).
> 
> Of course, these messages, like any other message that is sent across,
> need to begin with the usual rpmsg header. Its format is defined by
> struct rpmsg_hdr.
> 
> To send the message from the rtos to Linux, you then need to grab a
> buffer from the available ring (of the vring which is used by Linux to
> receive messages), fill it with the message, put it in the used ring,
> and kick the Linux side.

ok. Will try.

> 
>> Please also correct me if I read the code wrongly. that mailbox in omap
>> driver is used just to say which buffer contains that message. Is it
>> correct?
> 
> We're using the mailbox payload in order to indicate which vring has
> pending buffers.

ok.

> 
>> I can create 15 sw signals to tell rtos which buffer contains message.
> 
> You can also just use a single interrupt and then, when it is
> triggered, check both vrings for pending buffers. It's just another if
> statement and shouldn't be too much of an overhead.
> 
>> Will be help if I clear my code and send it to you for review? Maybe you
>> will see where the problem is.
> 
> I'm not sure I'll have the time to review it, but let's try to
> progress this way and see how it goes.
> 
> Sorry I couldn't answer faster this week - I'm in ELC and was a bit
> away from emails. I'll soon be flying back and that will keep me away
> from emails again, but b/o next week I'll be online again.

that's ok. I will be out of office next week and then I will have panda board
to check how it works on working sample. Unfortunately I don't have enough time
to play with rpmsg this week too.
IRC you mentioned somewhere that you maybe will have firmware which is possible to
compiled by gcc and which doesn't required that TI tools. Am I correct or that was
something totally different?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
