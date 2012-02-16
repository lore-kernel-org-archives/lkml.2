Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab2BPL3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:29:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2BPL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:28:59 -0500
MIME-Version: 1.0
X-Originating-IP: [108.60.121.130]
In-Reply-To: <4F3CC899.4070302@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
 <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
 <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com>
 <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
 <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com>
 <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu> <4F3CC899.4070302@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Feb 2012 12:28:38 +0100
Message-ID: <CAK=WgbaRF-L7M3VMZQdqFLUFOJuwFVkBH1hUNuJ51kSrzkaVjA@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: monstr@monstr.eu
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 10:12 AM, Michal Simek <monstr@monstr.eu> wrote:
> I should be more specific. Can you point me to remoteproc code which publish
> remote service based on them Linux rpmsg driver will be probed? It is rtos
> part of code.
> In your ELCE presentation is called rpmsg-client-sample service.

Sorry for the late response (I'm in ELC).

Yes, use the client sample (which is part of the submitted patch set)
and not the omx/server samples (which are public, but were never
submitted nor cleaned up).

The channels are created dynamically: the rpmsg bus designates address
53 for a name service, which listens to channel creation/removal
announcements coming from the remote processor. Take a look in
virtio_rpmsg_bus.c and you'll immediately see it.

Hope this helps,
Ohad.
