Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab1LOAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 19:25:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43546 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab1LOAZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 19:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <1323848398.3063.12.camel@dabdike>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<1323766382.8163.12.camel@dabdike>
	<4EE7B7B9.7060700@garzik.org>
	<CADDb1s1JwTbeFMsL4Vcz99PhgZKAMG05rgqankYCNeJLFRQSMg@mail.gmail.com>
	<1323848398.3063.12.camel@dabdike>
Date: Thu, 15 Dec 2011 09:25:51 +0900
Message-ID: <CAKYAXd9ncxETxTEP0Vy8CVyDJODsGuVT4jnpfQYCkcU8tXRtDA@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mdharm-usb@one-eyed-alien.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/14 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Wed, 2011-12-14 at 09:14 +0530, Amit Sahrawat wrote:
>> Just to add a thought - this issues is not related with ATA, this is
>> primarily related with HDD's with a USB interface i.e., SCSI <-> USB.
>> And, when I check my kernel config, CONFIG_ATA is not selected,
>> libata-scsi - this gets compiled only in case CONFIG_ATA is on.
>> Are these two things inter-related?
>
Hi. James.

> OK, so what you're telling us is that you're trying to correct a
> deficiency in a SATL inside a USB device?  The device itself is ATA but
> it doesn't use our libata connectors.
>
> I think in that case, the best way forwards is a mini-SATL correction
> layer within USB storage.  USB storage is certainly the place to
> black/white list whether this should be done.  ATA_16 is a bit of a
> dangerous command to be throwing around because it's known to crash
> various USB devices (and some old SCSI ones might even choke on it).
Okay, how about make some option in Kconfig of scsi or usb storage to
protect from the a bit of risk ATA_16 ?
The user can select this option to use stable filesystem on USB HDD.
>
> depending on how big this SATL ends up being we should consider whether
> it should share processing with the libata SATL.  If it's just a single
> mode sense, my instinct is that it's probably OK to implement separately
> (however, you need to use the libata headers ... no duplication of
> libata opcodes and status defines like you had in the original SCSI
> patch).  If there are more commands to correct on the way, it might be
> better as shared code.
I agree. I and Amit will check the best way between SATL or miniSATL
in usb_storage accoding to your advice.

> James
>
>
