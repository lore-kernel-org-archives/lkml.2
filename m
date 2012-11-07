Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2KGXjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:39:48 -0500
Received: from relay.ihostexchange.net ([66.46.182.51]:12808 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2KGXjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:39:47 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2012 18:39:46 EST
From: David Solda <dso@cypress.com>
To: Troy Abercrombia <ta@cypress.com>
CC: Kamal Mostafa <kamal@canonical.com>,
        =?utf-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        customercare <customercare@cypress.com>,
        "mario_limonciello@dell.com" <mario_limonciello@dell.com>
Date: Wed, 7 Nov 2012 18:30:11 -0500
Subject: Re: Why Cypress does not upstream its trackpad driver?
Thread-Topic: Why Cypress does not upstream its trackpad driver?
Thread-Index: Ac29QHKBRRiPGnZRS8eR6QltpiiOmg==
Message-ID: <EE629F2C-DD83-403C-AD73-E9ED966EEA91@cypress.com>
References: <CAFub=KTf2dWxM9=saG2JaNJpEioJM8rM3UBG9BkyxRN-+j0psQ@mail.gmail.com>
 <1352313131.2751.152.camel@fourier>
 <C825ADB6BE8AC2468577BFFCE7DF5B8A1F080FA111@VMBX133.ihostexchange.net>
In-Reply-To: <C825ADB6BE8AC2468577BFFCE7DF5B8A1F080FA111@VMBX133.ihostexchange.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA7NdqX8023380

Kamal,

My name is Dave Solda and I would be happy to answer any other questions that you have. Troy's response is correct however as in order to support the default Linux mouse class, our firmware would also have to be modified to do so, which cannot be done in system. Our packet protocol maxes out at an 8 byte packet, which requires a change to the Linux standard in this case.

Our goal in working with canonical was to provide something on Linux that would support multi-touch and not only have default single finger movement supported.

If I am mistaken and he Linux kernel would accept this, then we can proceed to upstream, however all indications we have is that this patch would be rejected.  If you (or others on from the locus alias) have any inputs, I would be happy to receive them.

Dave



On Nov 8, 2012, at 7:13 AM, "Troy Abercrombia" <ta@cypress.com> wrote:

> Hello Kamal
>
> Unfortunately, We're not able to upstream the driver as it would be denied because it changes the Linux mouse structure framework.
>
> Thanks
> Troy
> -----Original Message-----
> From: Kamal Mostafa [mailto:kamal@canonical.com]
> Sent: Wednesday, November 07, 2012 10:32 AM
> To: Ozan Ã‡aÄŸlayan
> Cc: linux-kernel@vger.kernel.org; linux-input@vger.kernel.org; dmitry.torokhov@gmail.com; customercare; mario_limonciello@dell.com
> Subject: Re: Why Cypress does not upstream its trackpad driver?
>
> On Tue, 2012-11-06 at 17:47 -0500, Ozan Ã‡aÄŸlayan wrote:
>> Hi,
>>
>> This driver [0] was written with a cooperation of Cypress, Dell and
>> Canonical Engineers within the last 3-4 months. It is very nice that
>> Cypress as a vendor cooperated with Canonical (Because Canonical works
>> with Dell for their Project Sputnik and Dell XPS13 is used as the main
>> hardware for that project and Dell XPS13 has this type of trackpad,
>> Bingo!), and I am also glad that Ubuntu users benefits from this
>> driver.
>>
>> The driver brings multi-touch scrolling, disable-while-tapping and
>> makes Fn+Fx touchpad disable/enable work for not only Dell XPS13 but
>> for all laptops having this trackpad (My Lenovo Ultrabook U300s for
>> example, I tested the patches on fedora 17's 3.6 kernel and it works
>> quiet nice)
>>
>> But what I am not getting that why NOBODY from Cypress/Canonical/Dell
>> isn't bothering to push this driver to upstream?
>
>
> In fact, Canonical is working on preparing the Cypress PS/2 trackpad driver for submitting upstream.
>
>
>> Is it too hard? I don't think so as the patches are quite non-invasive
>> and small.
>
>
> Your estimate of the work/risk involved not withstanding, I chose to deploy this experimental driver in stages -- first in the oem-specific "Sputnik project" kernel, then (recently) in the main Ubuntu kernel, then finally (soon) upstream -- so as to minimize regressions while shaking out the bugs.  For example, the version to which you linked does include a regression (breaks some ALPS touchpads) which we discovered only after deploying in Ubuntu.
>
> I expect to submit the Cypress driver upstream within two weeks.  Of course, my work on the driver is (and has been) publicly available[1].
>
> -Kamal Mostafa <kamal@canonical.com>
>
> [1] The latest version of this driver is represented by the patch set:
>    http://kernel.ubuntu.com/git?p=ubuntu%2Fubuntu-quantal.git&a=search&h=HEAD&st=commit&s=Cypress+PS%2F2
>
>
>>
>> Is the only distribution around is Ubuntu?
>> Is the only laptop sold in the world is Dell XPS13 with an Ubuntu?
>>
>> I'm not trying to be impolite but it hurts me to see that a vendor
>> produces an open-source driver for its device but makes use of it only
>> through a specific distribution.
>>
>> If Cypress is just beginning developing open-source drivers for their
>> devices, I hope that after this mail they will be much sensitive about
>> the issue and push their drivers even before the release of their
>> devices to make user experience flawless.
>>
>> (I googled and searched the archives of LKML and linux-input but
>> couldn't find a discussion or patch series about the driver. If I
>> missed it, ignore the whole stuff above)
>>
>> [0]: http://patchwork.ozlabs.org/patch/178903/
>

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
