Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1BVJTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:19:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63665 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1BVJTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:19:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Uvn50Sd5PxRI8GUMxoIoVmWZ5s9OM9sdD+9Am4m5w/ztX6nH6xzXrgvaaJWuGwL8rq
         FDrjU0xL7nv/5jDjgMBSGDicGLTA9+GOA8xRo1yNVPket2a3idWhZYQ2NOqnONXVf1M6
         4X1yeTumJMFRH0FqiN2vrBFIutRl3KQ8OihPw=
MIME-Version: 1.0
In-Reply-To: <4D62C5E1.9070307@pobox.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<4D514754.30203@ru.mvista.com>
	<AANLkTinE5x=hmQ6Oykw3Tb38HVeL5eHxjdnPOdMt930q@mail.gmail.com>
	<4D62C5E1.9070307@pobox.com>
Date: Tue, 22 Feb 2011 10:19:07 +0100
Message-ID: <AANLkTi=NQLxRQ+HAsjtWz5HFu7kaJw9sp50kKyK_ZTDv@mail.gmail.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 21, 2011 at 9:06 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 02/19/2011 04:25 AM, Bartlomiej Zolnierkiewicz wrote:
>>
>> Jeff, would it be possible to queue patches #01-15 for 2.6.39 if there
>> are no further concerns with them (thus leaving the merging of
>> PIIX-like drivers for later)?  They got additional testing on ICH4 and
>> they look mostly safe&  straight-forward compared to #16-21.
>
> This seems to directly contradict what you wrote earlier in the thread,
>
>        This is why patches were posted to mailing list with a request
>        for a real hardware testing:
>
>        "All testing was done using QEMU's PIIX3 controller emulation
>        so any testing with real EFAR, IT8213, old PIIX, RDC and
>        Radisys R82600 PATA controllers would be really appreciated.."
>
>        instead of request for a merge.  It was all there in initial
>        mail.
>
> and
>
>        I do not really care that much if it will be merged ever
>
> Regardless of this self-contradictory attitude, I do want useful patches and
> many of these patches seem useful.

Nothing self-contradictory there. :)

First quote is about patches #01-15 only, not whole patchset (#01-20)
like the second one, and I still don't care _that_ much personally if
it gets merged since it is all unpaid & voluntary work.

> So I will continue watching the Bart/Alan/Sergei threads play out, and then
> look at merging the result.  In the midst of all the arguing, productive
> work / forward progress is occurring, so the end result should be positive.
>
> It would be nice if we could get at least an "it works" test for the older
> hardware, since those are the changes /least/ likely to be tested by
> queueing to linux-next.

I was thinking about re-doing ata_piix part in a way that we could
merge it now by adding support for older PIIX-alikes to ata_piix and
making it enabled only if "all_piixalikes" module parameter is
specified.   This way older drivers would be left untouched for now
and we can easily get in-tree testing for a new code.  Does it sound
as a viable alternative?

Thanks,
Bartlomiej
