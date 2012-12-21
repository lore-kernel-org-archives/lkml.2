Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab2LUMCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:02:19 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57704 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab2LUMCM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:02:12 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Fri, 21 Dec 2012 13:02:02 +0100
Subject: RE: [RFCv2 05/11] remoteproc: Load firmware once.
Thread-Topic: [RFCv2 05/11] remoteproc: Load firmware once.
Thread-Index: Ac3fISzLO8uV1e1EQOKX/NgPfD/gqwATZdUg
Message-ID: <81C3A93C17462B4BBD7E272753C1057924576E4FEF@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021616.GC28692@WorkStation.localnet>
In-Reply-To: <20121221021616.GC28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido and Ohad,

> In case the remote processor is added, booted and then rebooted, the
> program sections wont be reinitialized. This can be a bit problematic,
> since the firmware might assume values are initialized in its data
> sections.
> 
> How about the following alternative approach - instead of loading the
> firmware in advance, we could allocate just a small (private) buffer,
> holding a copy of the resource table. Our copy will be updated with the
> addresses of the vrings we allocate, along with the notification ids.
> Each time the remote processor is booted, we could reload the firmware
> and overwrite the resource table section with our own private copy.
> virtio's configuration space and status will probably need to be updated
> in both copies of the resource table, so it would be consistent across
> boots.

Thank you for review comments Ido!

Hm, are you suggesting to load firmware once or twice?

We could keep loading firmware twice and copy
the resource table. This solves the issue of initializing variables.
We could then keep the original approach with loading firmware
twice. But one question comes to mind:  is it safe to assume that
the firmware's resource table is unchanged after a reboot?

[Ohad Aug 10, 2012 wrote.]
>The general direction I have in mind is to put the resource table in
>its final location while we do the first pass of fw parsing.
...
>This will solve all sort of open issues we have (or going to have soon):
...
>1. dynamically-allocated address of the vrings can be communicated
>2. vdev statuses can be communicated
>3. virtio config space will finally become bi-directional as it should
>4. dynamically probed rproc-to-rproc IPC could then take place
>
>It's the real deal :)
>
>The only problem with this approach is that the resource table isn't
>reloaded throughout cycles of power up/down, and that is insecure.
>We'll have to manually reload it somewhere after the rproc is powered
>down (or before it is powered up again).
>
>This change will break existing firmwares, but it looks required and inevitable.

This patch is a stab on implementing what Ohad suggested originally, and loads firmware
once. We can probably make this work as well, but I missed handling reload properly.
For this to work I need to add support for reloading firmware upon reboot.

I go on vacation for a while now, but please get back to me on what direction we
should go in: loading once or twice :-)

Regards,
Sjur
