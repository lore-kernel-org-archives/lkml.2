Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab2JKLOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:14:30 -0400
Received: from multi.imgtec.com ([194.200.65.239]:28408 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352Ab2JKLO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:14:27 -0400
Message-ID: <5076A9F3.7070403@imgtec.com>
Date: Thu, 11 Oct 2012 12:13:55 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com> <5076990C.4080406@acm.org>
In-Reply-To: <5076990C.4080406@acm.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_10_11_12_13_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/12 11:01, Bart Van Assche wrote:
> On 10/11/12 11:15, James Hogan wrote:
>> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
>> used in struct osd_cdb_head, but it isn't marked as packed. Some
>> architectures will round the struct size up which triggers BUILD_BUG_ON
>> compile errors in osd_initiator.c when the outer structs are unexpected
>> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> ---
>>   include/scsi/scsi.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
>> index 66216c1..3beaef3 100644
>> --- a/include/scsi/scsi.h
>> +++ b/include/scsi/scsi.h
>> @@ -198,7 +198,7 @@ struct scsi_varlen_cdb_hdr {
>>       __u8 additional_cdb_length;         /* total cdb length - 8 */
>>       __be16 service_action;
>>       /* service specific data follows */
>> -};
>> +} __packed;
>>
>>   static inline unsigned
>>   scsi_varlen_cdb_length(const void *hdr)
> 
> Hello James,
> 
> Are you aware that __packed can also be used on individual struct
> members and that doing so has a lower performance penalty than using the
> __packed attribute on an entire struct ? See e.g. <linux/sysv_fs.h> for
> an example.

Hi Bart,

Thanks, I wasn't aware of that, however the problem is the size of the
struct as a whole rather than the alignment or offsets of any individual
data members. E.g. adding __attribute__((packed,aligned(2))) to the
16bit member doesn't reduce the struct to 10 bytes, or change the offset
from 8 bytes.

Cheers
James

