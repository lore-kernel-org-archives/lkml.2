Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0IONz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:55:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61994 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0IONz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=O1/Z4SDuKTS8tJ1h9m2K2b2T6i521E1uBjTf5WREESnzRj1i5PuIfN4MqRA00ro+Va
         55kFp8qKpuS4wBkcRLgAJ8O1b8IrqbimswZX6CDW0NlVCKR4ClfC+BuH+BSbarHh7Gnz
         dmbfZYfWcQMbSdbaKlu2ljW5ho6C8sfAkwdw8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimd_sRpOYaurOT0iSbfd0pMZvhxgUcaqbQvSobu@mail.gmail.com>
References: <AANLkTikHM+o_FCgnVzGhs8UtQ_geXFzKNQpGSZiEN7sx@mail.gmail.com>
	<AANLkTimd_sRpOYaurOT0iSbfd0pMZvhxgUcaqbQvSobu@mail.gmail.com>
Date: Wed, 15 Sep 2010 19:25:56 +0530
Message-ID: <AANLkTimO1UK+WA8Mc3Myi3gWBpD=D7tXDOX104a8NMKW@mail.gmail.com>
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

On Tue, Sep 14, 2010 at 8:54 PM, venki kaps <venkiece2005@gmail.com> wrote:
> On Tue, Sep 14, 2010 at 1:28 AM, venki kaps <venkiece2005@gmail.com> wrote:
>> Dear all,
>>
>> I have been facing an issue with OMAP3 PM with DSP MMU Fault (Kernel 2.6.32).
>>
>> The issue is describing as below mentioned way,
>>        1). The Device is getting DSP MMU Fault when playing MP4 video clip.
>>
>> The system is not hitting off mode in the below scenario,
>>        2). System boot ->play mp4 clip ->DSP MMU Fault -> allow off
>> mode -----------> Never hits off mode
>>
>> But surprisingly the system is hitting off mode in the below scenario,
>>       3). System boot ->allow off mode ->play mp4 clip ->DSP MMU
>> Fault -> allow off mode -----------> perfectly works
>>
>>
>>  - Could you please describe the root cause about the above issues 1 & 2?
>>  - How could solve the above issues?
>
> I have found the issue with UART3.
> In System configuration register (SYSC),-
>             IDLEMODE  - Smart idle -------> working scenario  ------>
> system hits off mode.
>             IDLEMODE  - No idle -------> Non working scenario
> ------> system never hits off mode.
>
> Could you please explain why UART3 is not able to hit smart idle after
> DSP MMU fault ( System boot ->play mp4 clip ->DSP MMU Fault -> allow
> off -----------> Never hits off mode).,

My problem is resolved.GPtimer7 was not reset during the MMU FAULT
occurrence before the first power cycle.
So this pending interrupt is preventing the system sleep entry.
Now it works fine after resetting Gptimer7 in pm suspend path.

> Thanks in advance.
>
>> Best Regards,
>> Venkii
>>
>
