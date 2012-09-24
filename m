Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2IXTiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:38:02 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3720 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718Ab2IXTiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:38:00 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <5060B675.8090805@broadcom.com>
Date: Mon, 24 Sep 2012 12:37:25 -0700
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Julia Lawall" <Julia.Lawall@lip6.fr>
cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/scsi/bnx2fc/bnx2fc_io.c: Remove
 potential NULL dereference
References: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
 <1344959388-19719-3-git-send-email-Julia.Lawall@lip6.fr>
 <504A3BBF.5030604@broadcom.com>
In-Reply-To: <504A3BBF.5030604@broadcom.com>
X-WSS-ID: 7C7E69983PS2527288-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 11:23 AM, Bhanu Prakash Gollapudi wrote:
> On 8/14/2012 8:49 AM, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> If the NULL test is necessary, the initialization involving a 
>> dereference of
>> the tested value should be moved after the NULL test.
>>
>> The sematic patch that fixes this problem is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> type T;
>> expression E;
>> identifier i,fld;
>> statement S;
>> @@
>>
>> - T i = E->fld;
>> + T i;
>>    ... when != E
>>        when != i
>>    if (E == NULL) S
>> + i = E->fld;
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>   drivers/scsi/bnx2fc/bnx2fc_io.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c 
>> b/drivers/scsi/bnx2fc/bnx2fc_io.c
>> index 73f231c..1dd82db 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
>> @@ -686,7 +686,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd 
>> *sc_cmd, u8 tm_flags)
>>   {
>>       struct fc_lport *lport;
>>       struct fc_rport *rport = 
>> starget_to_rport(scsi_target(sc_cmd->device));
>> -    struct fc_rport_libfc_priv *rp = rport->dd_data;
>> +    struct fc_rport_libfc_priv *rp;
>>       struct fcoe_port *port;
>>       struct bnx2fc_interface *interface;
>>       struct bnx2fc_rport *tgt;
>> @@ -712,6 +712,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd 
>> *sc_cmd, u8 tm_flags)
>>           rc = FAILED;
>>           goto tmf_err;
>>       }
>> +    rp = rport->dd_data;
>>
>>       rc = fc_block_scsi_eh(sc_cmd);
>>       if (rc)
>>
>>
> Thanks Julia.
>
> Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

James, can you please pick up this patch also for 'misc'?

Thanks,
Bhanu
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



