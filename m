Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2A0Gla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:41:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64179 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2A0GlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:41:22 -0500
X-AuditID: cbfee60e-b7ca4ae000007903-4d-4f22471035ed
Date: Fri, 27 Jan 2012 06:41:20 +0000 (GMT)
From: =?euc-kr?B?wPyzssDn?= <namjae.jeon@samsung.com>
Subject: Re: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>
Reply-to: namjae.jeon@samsung.com
MIME-version: 1.0
X-MTR: 20120127052828534@namjae.jeon
Msgkey: 20120127052828534@namjae.jeon
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120127052828534@namjae.jeon
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19811243.113401327646477519.JavaMail.weblogic@epml09>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0R6fxnD017731

I changed recipients.

I hope you answer us about the below email.

Thanks. 
------- Original Message -------
Sender : Amit Sahrawat<amit.sahrawat83@gmail.com> 
Date   : 2012-01-27 14:20 (GMT+09:00)
Title  : Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails

Dear James/Jeff,

I have few questions regarding the code changes which can be accepted
in this regards.

In our scenario we are not making use of CONFIG_ATA, but still if that
is the proper manner to bring out the changes ? then we can enable and
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
>> deficiency in a SATL inside a USB device? ?The device itself is ATA but
>> it doesn't use our libata connectors.
>>
>> I think in that case, the best way forwards is a mini-SATL correction
>> layer within USB storage. ?USB storage is certainly the place to
>> black/white list whether this should be done. ?ATA_16 is a bit of a
>> dangerous command to be throwing around because it's known to crash
>> various USB devices (and some old SCSI ones might even choke on it).
> Okay, how about make some option in Kconfig of scsi or usb storage to
> protect from the a bit of risk ATA_16 ?
> The user can select this option to use stable filesystem on USB HDD.
>>
>> depending on how big this SATL ends up being we should consider whether
>> it should share processing with the libata SATL. ?If it's just a single
>> mode sense, my instinct is that it's probably OK to implement separately
>> (however, you need to use the libata headers ... no duplication of
>> libata opcodes and status defines like you had in the original SCSI
>> patch). ?If there are more commands to correct on the way, it might be
>> better as shared code.
> I agree. I and Amit will check the best way between SATL or miniSATL
> in usb_storage accoding to your advice.
>
>> James
>>
>>
<p>&nbsp;</p><p>&nbsp;</p>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
