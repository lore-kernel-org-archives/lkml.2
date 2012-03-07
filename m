Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab2CGPNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:13:45 -0500
Received: from xyratex195.xyratex.com ([194.131.166.195]:43181 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757700Ab2CGPNo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:13:44 -0500
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Mark Salyzyn <mark_salyzyn@xyratex.com>
In-Reply-To: <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn>
Date: Wed, 7 Mar 2012 09:58:44 -0500
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, lindar_liu <lindar_liu@usish.com>,
        James Bottomley <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com> <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn>
To: santoshprasadnayak@gmail.com
X-Mailer: Apple Mail (2.1257)
X-OriginalArrivalTime: 07 Mar 2012 14:58:48.0358 (UTC) FILETIME=[CD0D6460:01CCFC72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK on one point.

The fw_flash_Update_resp structure erroneously defines tag as a dma_addr_t, when in fact it should be an __le32, as the response hTag is reported in this field. The removal of the le32_to_cpu(ppayload->tag) was done to remove a warning, but is incorrect. The warning should have been solved by correctly defining the tag element in the structure.

Sincerely -- Mark Salyzyn

On Feb 26, 2012, at 11:51 PM, Jack Wang wrote:

> Thanks for fix.
> Acked-by: Jack Wang <jack_wang@usish.com>
>> 
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>> 
>> 1. Fix endian issue.
>> 2. Fix the following warning :
>>    " drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: comparison
>>      between 'enum sas_device_type' and 'enum sas_dev_type'".
>> 3. Few code optimization.
>> 
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>> . . .
>> @@ -3149,7 +3152,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info
>> *pm8001_ha, void *piomb)
>> 	struct fw_control_ex	fw_control_context;
>> 	struct fw_flash_Update_resp *ppayload
>> 		(struct fw_flash_Update_resp *)(piomb + 4);
>> -	u32 tag = le32_to_cpu(ppayload->tag);
>> +	u32 tag = ppayload->tag;
>> 	struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
>> 	status = le32_to_cpu(ppayload->status);
>> 	memcpy(&fw_control_context,

