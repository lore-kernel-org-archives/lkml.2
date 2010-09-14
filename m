Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0INPYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:24:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36443 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0INPYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=BYYdCfuZGmI68Gl0YP959sXdUdM7xgBk2BGc7CPMHwV/mfOUhQdFhs3bLxDnyefyub
         wDDKc1q/1aH8IwsoH3DumIM7CRaTlBxYiREYBEgKfSsLcMBwJEZJ4k7LUzo0r+7yaD/4
         R12/CmqpbEHsjwIzZiaWZtgpKhldgTMGWR5Xg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikHM+o_FCgnVzGhs8UtQ_geXFzKNQpGSZiEN7sx@mail.gmail.com>
References: <AANLkTikHM+o_FCgnVzGhs8UtQ_geXFzKNQpGSZiEN7sx@mail.gmail.com>
Date: Tue, 14 Sep 2010 20:54:22 +0530
Message-ID: <AANLkTimd_sRpOYaurOT0iSbfd0pMZvhxgUcaqbQvSobu@mail.gmail.com>
Subject: Re: OMAP3 DSP MMU fault + off mode issue
From: venki kaps <venkiece2005@gmail.com>
To: omar.ramirez@ti.com, h-kanigeri2@ti.com, ameya.palande@nokia.com,
        fernando.lugo@ti.com, x0hebbar@ti.com, ernesto@ti.com,
        felipe.contreras@gmail.com, s-anna@ti.com, grgupta@ti.com,
        ivan.gomez@ti.com, ext-andriy.shevchenko@nokia.com, x0095078@ti.com,
        deepak.chitriki@ti.com, nm@ti.com, ext-phil.2.carmody@nokia.com,
        ohad@wizery.com, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 1:28 AM, venki kaps <venkiece2005@gmail.com> wrote:
> Dear all,
>
> I have been facing an issue with OMAP3 PM with DSP MMU Fault (Kernel 2.6.32).
>
> The issue is describing as below mentioned way,
>        1). The Device is getting DSP MMU Fault when playing MP4 video clip.
>
> The system is not hitting off mode in the below scenario,
>        2). System boot ->play mp4 clip ->DSP MMU Fault -> allow off
> mode -----------> Never hits off mode
>
> But surprisingly the system is hitting off mode in the below scenario,
>       3). System boot ->allow off mode ->play mp4 clip ->DSP MMU
> Fault -> allow off mode -----------> perfectly works
>
>
>  - Could you please describe the root cause about the above issues 1 & 2?
>  - How could solve the above issues?

I have found the issue with UART3.
In System configuration register (SYSC),-
             IDLEMODE  - Smart idle -------> working scenario  ------>
system hits off mode.
             IDLEMODE  - No idle -------> Non working scenario
------> system never hits off mode.

Could you please explain why UART3 is not able to hit smart idle after
DSP MMU fault ( System boot ->play mp4 clip ->DSP MMU Fault -> allow
off -----------> Never hits off mode).,

Thanks in advance.

> Best Regards,
> Venkii
>
