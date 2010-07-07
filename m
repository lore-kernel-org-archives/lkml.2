Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0GGQQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:16:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60040 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0GGQQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=foGBDnDVHlcV2DWs6ZXoR1GSrtGH9WMY377szXW6BgHmo+C6lFzzqJSDa3lQHYjJK3
         VfzgkgeUKgnP4AmVQsVKBi8Y2uDha36r2y92NkR1CjjLn9txxIuAVNJv1vobHLYj2XDK
         mWS/+gwGvnO5+YYbbUFbLh+fZLCGgrwKkO5w8=
MIME-Version: 1.0
In-Reply-To: <4C34A1D5.1090202@kernel.org>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F61AB.9030806@kernel.org>
	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
	<4C317C04.20500@kernel.org>
	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
	<4C32CE50.6010501@kernel.org>
	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
	<4C341598.6040004@kernel.org>
	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
	<4C34A1D5.1090202@kernel.org>
Date: Wed, 7 Jul 2010 09:15:59 -0700
Message-ID: <AANLkTikAENeTTHGiRO_tj3r0_rqXdFZ7KJDLYuIRpM-i@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 8:48 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 07/07/2010 05:34 PM, Mark Knecht wrote:
>> OK - I don't know if this was you intention but since adding this
>> patch I've not had a single drive missing failure. I've cold booted
>> about 8 times and warm booted at least 20 times. Every one has come up
>> fine. I've even gone so far as to turn off the UPS and sit for 5
>> minutes before cold booting. Still nothing fails right now.
>>
>> I've had this sort of statistical thing happen before where it hasn't
>> failed for days, maybe even weeks, but then it starts failing and
>> fails every time for awhile. Over the past few days working with you
>> I've never had to reboot more than twice to get you a file. Now I've
>> tried 30 times this morning and I've come up with nothing.
>>
>> I will continue to watch the machine and send you the failing dmesg
>> file whenever I finally get it. For now I can only attach the passing
>> file showing the patch is now included.
>
> It seems like SIDPR is a bit more unreliable than the current code can
> handle and the added delay and read could have affected the result.
> Eh... weird.  Can you please apply the attached patch instead?  The
> only difference is it will print out two SControl values instead of
> one.  ie. "XXX SControl after resume = AAA BBB, tries=T".  Can you
> please try to boot multiple times and see if AAA and BBB differ
> anytime?  If that happens, please attach the boot log.  Also, if you
> see one with T > 1, please attach that one too.
>
> Thanks.
>
> --
> tejun
>

Certainly. Is there a way to reverse the previous patch?

c2stable linux # patch -p1 --dry-run <~mark/Downloads/resume-dbg-1.patch
patching file drivers/ata/libata-core.c
Hunk #1 succeeded at 3798 (offset 86 lines).
Hunk #2 succeeded at 3833 with fuzz 2 (offset 94 lines).
Hunk #3 FAILED at 6109.
1 out of 3 hunks FAILED -- saving rejects to file drivers/ata/libata-core.c.rej
c2stable linux #

I assume this is failing because your patch is over the plain kernel,
not the one I've patched?

Thanks,
Mark
