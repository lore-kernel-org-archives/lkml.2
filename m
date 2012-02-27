Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2B0KPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:15:07 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56510 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2B0KPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:15:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F47E4B1.10405@redhat.com>
References: <CAOcJUbwqtvWy+O5guZBj7T2f61=8oe+gwqH6Fbifu1PVz+THzQ@mail.gmail.com>
	<4F47E4B1.10405@redhat.com>
Date: Mon, 27 Feb 2012 05:15:04 -0500
X-Google-Sender-Auth: b-cdIr9GCMHl4zVMWPdsRNwMBbo
Message-ID: <CAOcJUby_KmrcYC=728S3Oc3sFWsCRpb0NXU8jv6gOk_K0JvmbA@mail.gmail.com>
Subject: Re: pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mike Isely <isely@pobox.com>, linux-media <linux-media@vger.kernel.org>,
        Communications nexus for pvrusb2 driver <pvrusb2@isely.net>,
        stable@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 2:27 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 07-02-2012 15:08, Michael Krufky escreveu:
>> There are some new revisions of the HVR-1900 around whose DVB-T
>> support is broken without this small bug-fix.  Please merge asap -
>> this fix needs to go to stable kernels as well.  It applies cleanly
>> against *all* recent kernels.
>>
>> The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
>>
>>   Linux 3.2 (2012-01-04 15:55:44 -0800)
>>
>> are available in the git repository at:
>>   git://linuxtv.org/mkrufky/hauppauge surrey
>>
>> Michael Krufky (1):
>>       pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5
>>
>>  drivers/media/video/pvrusb2/pvrusb2-devattr.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>
>> The D1F5 revision of the WinTV HVR-1900 uses a tda18271c2 tuner
>> instead of a tda18271c1 tuner as used in revision D1E9. To
>> account for this, we must hardcode the frontend configuration
>> to use the same IF frequency configuration for both revisions
>> of the device.
>
> No, you don't need to hardcode the IF. Just use the get_if_frequency
> callback at the demod, and it will work with whatever frequency you
> use at the tuner.
>
> Regards,
> Mauro

(apologies for delayed reply - I am travelling in Europe this month
and not checking all my email every day)

Mauro,

get_if_frequency will work, but for *optimal* settings for the
hardware that my company manufactures, this is it.  The hardcoded IF
is the correct setting for *this* hardware.  There are more factors
than just a tuner and demodulator, here.  I know the board layout and
the crystal configurations, and we did extensive testing.  Sure, you
can use get_if_frequency and it will "work" ... but when I have
information about how it will work *best* then you should merge my
patch.

This is the fix.  You can merge it or you will not merge it.  I did my
part, Mauro.  My customers need this fix and I will not argue.

ALSO, for -stable, there is no get_if_frequency.  I cannot have the
patch merged into stable unless you merge it into mainline. There is
no time for opinion - only facts.  Please merge.

-MK
