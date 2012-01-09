Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2AIWN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:13:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50791 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2AIWN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <4EEDFBCF.4040802@nod.at>
References: <1321577067-26332-1-git-send-email-richard@nod.at>
 <47D23AD8469A2B448F33C24BD7A39BD9108C7178@RTPMVEXC1-PRD.hq.netapp.com> <4EEDFBCF.4040802@nod.at>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 9 Jan 2012 17:13:05 -0500
X-Google-Sender-Auth: vAlEzXbii_ywlfHQ7WhRoVjQeXY
Message-ID: <CAMM=eLeXa7qLMyG+njL9yuYDkUAxTNLV5eHi+y_=X+1eDVwZ_g@mail.gmail.com>
Subject: Re: [PATCH] scsi_dh_rdac: Fix error path
To: Richard Weinberger <richard@nod.at>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, JBottomley@parallels.com,
        Somasundaram.Krishnasamy@lsi.com, yanling.qi@lsi.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 9:42 AM, Richard Weinberger <richard@nod.at> wrote:
> Am 18.11.2011 15:34, schrieb Moger, Babu:
>> Looks good to me..
>>
>>> -----Original Message-----
>>> From: Richard Weinberger [mailto:richard@nod.at]
>>> Sent: Thursday, November 17, 2011 6:44 PM
>>> To: JBottomley@parallels.com
>>> Cc: Moger, Babu; Somasundaram.Krishnasamy@lsi.com; yanling.qi@lsi.com;
>>> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Richard
>>> Weinberger
>>> Subject: [PATCH] scsi_dh_rdac: Fix error path
>>>
>>> If create_singlethread_workqueue() failes, rdac_init should fail too.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>  drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> b/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> index 1d31279..2802394 100644
>>> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> @@ -934,6 +934,8 @@ static int __init rdac_init(void)
>>>      if (!kmpath_rdacd) {
>>>              scsi_unregister_device_handler(&rdac_dh);
>>>              printk(KERN_ERR "kmpath_rdacd creation failed.\n");
>>> +
>>> +            r = -EINVAL;
>>>      }
>>>  done:
>>>      return r;
>>> --
>>> 1.7.7.3
>>
>
> James,
>
> can you please pickup this patch?

James, was this the one that you said was overlooked?

In any case, please apply, and for good measure:

Acked-by: Mike Snitzer <snitzer@redhat.com>
