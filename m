Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2DSGKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:10:10 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44614 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab2DSGKH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120418155643.5b6eff01.akpm@linux-foundation.org>
References: <1334734733-13640-1-git-send-email-svenkatr@ti.com> <20120418155643.5b6eff01.akpm@linux-foundation.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Thu, 19 Apr 2012 11:39:45 +0530
Message-ID: <CANfBPZ_dvYxDMiV=c5RH7TSe8P6TUNKv5T7sEJvPGa4hdEXtHA@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] scsi/ufs: Fix evaluation of task_failed status
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, santoshsy@gmail.com, linkinjeon@gmail.com,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 4:26 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Please cc James and linux-scsi on drivers/scsi patches?
>
> On Wed, 18 Apr 2012 13:08:53 +0530
> Venkatraman S <svenkatr@ti.com> wrote:
>
>> Else FAILED would be set even if task_result was
>> originally equal to UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.
>
> This changelog is inadequate.  It failed to describe the end-user
> impact of the bug.  Without this information we cannot decide which
> kernel version(s) should be patched.  Please always fully describe a
> bug when fixing it.
>
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
>>               task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
>>               task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
>>
>> -             if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
>> +             if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
>>                   task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
>>                       task_result = FAILED;
>>       } else {
>
> And the title of the patch is poor.  There is no "task_failed" here.
> Something like "fix evaluation of task completion code" would be
> better?

Ok. I will send an updated version of the patch.
Regards,
Venkat.
