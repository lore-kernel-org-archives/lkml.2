Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1LSL7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:59:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1LSL7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:59:18 -0500
Message-ID: <4EEF2714.1080402@suse.de>
Date: Mon, 19 Dec 2011 12:59:16 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
References: <1321572864-23628-1-git-send-email-richard@nod.at>  <4EEDFC16.90303@nod.at> <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com> <4EEDFE4E.6090104@nod.at>
In-Reply-To: <4EEDFE4E.6090104@nod.at>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2011 03:53 PM, Richard Weinberger wrote:
> Am 18.12.2011 15:45, schrieb James Bottomley:
>> On Sun, 2011-12-18 at 15:43 +0100, Richard Weinberger wrote:
>>> Am 18.11.2011 00:34, schrieb Richard Weinberger:
>>>> scsi_dh_attach() should return a negative value on error.
>>>>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> ---
>>>>  include/scsi/scsi_dh.h |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
>>>> index e3f2db2..e07ab10 100644
>>>> --- a/include/scsi/scsi_dh.h
>>>> +++ b/include/scsi/scsi_dh.h
>>>> @@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *name)
>>>>  }
>>>>  static inline int scsi_dh_attach(struct request_queue *req, const char *name)
>>>>  {
>>>> -	return SCSI_DH_NOSYS;
>>>> +	return -SCSI_DH_NOSYS;
>>>>  }
>>>>  static inline void scsi_dh_detach(struct request_queue *q)
>>>>  {
>>>
>>> James,
>>>
>>> can you please pickup this patch?
>>
>> It still needs an ack from rdac people (other one just got overlooked).
>>
> 
> Who are the rdac people?
> I sent the patch to all addresses reported by get_maintainers.pl.
> 
Nack.

This patch is wrong.

scsi_dh_attach() (and, incidentally, scsi_dh_set_params()) should
return a standard error value. SCSI_DH_XXX are internal to
device_handler and should never see the light of day.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
