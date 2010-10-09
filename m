Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab0JIMLB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:11:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54243 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0JIMK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Fh7TfyVs/8sYrLCr44jRTSYU9VLolEsGI57l6KExNXCJAhU9E8UPMaw2nzuwGPb/Zk
         wERXMGBa9OY0lK8m7joU+zRyRX8V3WUG4W7ZX3yLdlnoVEGrxn025NRQaLMRGxs14+3/
         lvfy9nxuYCBPmfk/QavHKJV0Y+cKFqC8M7Cnk=
MIME-Version: 1.0
In-Reply-To: <AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
	<201010091311.26335.arnd@arndb.de>
	<AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
Date: Sat, 9 Oct 2010 15:10:57 +0300
Message-ID: <AANLkTi=37SCuwwze4KS_yOdmi8bvJP_OexHaYLw-AXfJ@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 2:43 PM, Dave Airlie <airlied@gmail.com> wrote:
>> The few drivers that may be hit by this are typically in drivers/staging
>> exactly because issues like this have not been fixed yet.
>>
>> We should probably just fix the non-staging drivers that are hit by
>> this now and declare the issue done.
>>
>> When you say that "many drivers broken", can you list the ones you know
>> about? It would probably help resolve this the right way.
>
> I'm guessing some closed source graphics drivers for ARM do all kinds
> of wrong crap, and Nokia use them a lot, and nobody wants to tell the
> closed vendors to change their drivers because it costs money.

You are over simplifying things.

 1) The code is open[1]
 2) the decision comes from TI, Nokia can only do so much before shipping
 3) I know many people in Nokia have pushed very hard, and cleaned up
the driver a lot themselves
 4) There are other companies, Intel is using SGX too

Anyway, there are other examples, like tidspbridge, which Nokia has
spent a lot of time cleaning up, and TI made a great effort to push
into staging. And others already in mainline, like
sh_mobile_ceu_camera.

[1] http://meego.gitorious.org/meego-os-base/kernel-source/trees/master/patches

-- 
Felipe Contreras
