Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2A0FU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:20:56 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59114 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab2A0FUy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9ncxETxTEP0Vy8CVyDJODsGuVT4jnpfQYCkcU8tXRtDA@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<1323766382.8163.12.camel@dabdike>
	<4EE7B7B9.7060700@garzik.org>
	<CADDb1s1JwTbeFMsL4Vcz99PhgZKAMG05rgqankYCNeJLFRQSMg@mail.gmail.com>
	<1323848398.3063.12.camel@dabdike>
	<CAKYAXd9ncxETxTEP0Vy8CVyDJODsGuVT4jnpfQYCkcU8tXRtDA@mail.gmail.com>
Date: Fri, 27 Jan 2012 10:50:52 +0530
Message-ID: <CADDb1s1cGJTAQNMvSwpt15YiLiCo0JwAqW+V611e__v8gR4fFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>, Nam-Jae Jeon <namjae.jeon@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mdharm-usb@one-eyed-alien.net
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear James/Jeff,

I have few questions regarding the code changes which can be accepted
in this regards.

In our scenario we are not making use of CONFIG_ATA, but still if that
is the proper manner to bring out the changes – then we can enable and
make changes in the respective file which seems to be libata-scsi.c

We need a mechanism wherein we can query and then get the response so
that we set the WCE bit accordingly. For that matter, I think we can
introduce some function in libata-scsi.c and then call that function
from either drivers/scsi/sd.c or drivers/usb/storage/scsiglue.c

Please share your valuable inputs on how and where actually these
changes should be done. Otherwise, there is again a chance that our
changes gets rejected.

Please help in this regards.

Thanks & Regards,
Amit Sahrawat



On Thu, Dec 15, 2011 at 5:55 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> 2011/12/14 James Bottomley <James.Bottomley@hansenpartnership.com>:
>> On Wed, 2011-12-14 at 09:14 +0530, Amit Sahrawat wrote:
>>> Just to add a thought - this issues is not related with ATA, this is
>>> primarily related with HDD's with a USB interface i.e., SCSI <-> USB.
>>> And, when I check my kernel config, CONFIG_ATA is not selected,
>>> libata-scsi - this gets compiled only in case CONFIG_ATA is on.
>>> Are these two things inter-related?
>>
> Hi. James.
>
>> OK, so what you're telling us is that you're trying to correct a
>> deficiency in a SATL inside a USB device?  The device itself is ATA but
>> it doesn't use our libata connectors.
>>
>> I think in that case, the best way forwards is a mini-SATL correction
>> layer within USB storage.  USB storage is certainly the place to
>> black/white list whether this should be done.  ATA_16 is a bit of a
>> dangerous command to be throwing around because it's known to crash
>> various USB devices (and some old SCSI ones might even choke on it).
> Okay, how about make some option in Kconfig of scsi or usb storage to
> protect from the a bit of risk ATA_16 ?
> The user can select this option to use stable filesystem on USB HDD.
>>
>> depending on how big this SATL ends up being we should consider whether
>> it should share processing with the libata SATL.  If it's just a single
>> mode sense, my instinct is that it's probably OK to implement separately
>> (however, you need to use the libata headers ... no duplication of
>> libata opcodes and status defines like you had in the original SCSI
>> patch).  If there are more commands to correct on the way, it might be
>> better as shared code.
> I agree. I and Amit will check the best way between SATL or miniSATL
> in usb_storage accoding to your advice.
>
>> James
>>
>>
