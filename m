Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1IBTOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:14:48 -0400
Received: from nm30-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.69]:25231 "HELO
	nm30-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278Ab1IBTOr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:14:47 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Sep 2011 15:14:47 EDT
X-Yahoo-Newman-Id: 162331.48254.bm@omp1057.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:References:Mime-Version:In-Reply-To:X-Apple-Yahoo-Original-Message-Folder:Content-Type:Content-Transfer-Encoding:Message-Id:Cc:X-Mailer:From:X-Apple-Yahoo-Replied-Msgid:Subject:Date:To;
  b=6eUpdvuYe1VfDiyA6M+frkGd4mbBkrqToJFWFY2TA3l4WyvJyP/756oGz7pGhETv4I6Eh3jQf0y8aHyrJAO+ahmXWweRspkxx/ZnGlzv3ZueisBRLy7AwJJxk6kCNZBFmYLMGXdhk4OpK4qTX1U6Xf8Iy0RYj0IVJ2047qcnmmU=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: P0SZD6QVM1mbmt962uUFfjW8jpmCd78x1NvWTGzrlvXnPha
 nW8izOYBMBTPGGeB8MlNreqoFdJOV.ruQL454dHeYyPGfZXS.3bCTwzG8WWO
 QSUmPBrZwx_O1dm9o9VTlipYer7bJGa2eL1RiWrCF59gjaIJDvh8cJ3UxPJt
 tvThMbPkuJJ61B2xqkQAwm06DCs92zt_ZuF5uD4udeAznl7uHC751LlYH4ub
 ufj5_WSvDvdwgMo5bM32zOsiAuzXAhjwioKNwPxtKX0hx7mCxClgq3dlRZkX
 Os_beBR6rpB99jvB.04gb3G1CVOLtniRbvxMu4U._SQFUzgaYsfSBh78HEUQ
 P00L3OaI7eV099cQftE2rtBigocmNAhpaU10I0HbLGXu_LiBeQqlu.Of5K2Y
 fOzh5plog8c7XE5mAYRDh1D5bZiRTK8FmQ71M5gGPSze40IUvBqY7sQwHZzB
 _Brus4q32vjIRHRMn5A2R4Ms7KR00g7QQAkrfkAIeMhv5Enql_R5BXy8QIj9
 PPQYDnDd.6RunF.A3AI58.3JADkpKiQ_Il.Wwr52wchIcflHtuOTmB5c8Oui
 cf.nzhZEIOy8c5fnisEE.5ELwKKZ8bngSw5i3qXW.NvtGZMNYQkblvERaKkD
 wPKLVjuXxIBY-
X-Yahoo-SMTP: Jr5mEQOswBBUeQ6oSnePwwxoZ1M-
References: <CAM9Y=f6eSgxsbrO11d0ux72NJip14xGQDeX84VWb9uiBtEVsjA@mail.gmail.com> <20110902181826.GA29848@kroah.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
In-Reply-To: <20110902181826.GA29848@kroah.com>
X-Apple-Yahoo-Original-Message-Folder: Inbox
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <CB97E92C-3990-418B-BA04-94073E011ECE@yahoo.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb-devel@lists.sourceforge.net>,
        "usb-storage@lists.one-eyed-alien.net" 
	<usb-storage@lists.one-eyed-alien.net>
X-Mailer: iPhone Mail (8J2)
From: Luben Tuikov <ltuikov@yahoo.com>
X-Apple-Yahoo-Replied-Msgid: 1_7615510_AEnPjkQAAM3DTmEg0wkhUTVigmA
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Fri, 2 Sep 2011 12:08:44 -0700
To: Greg KH <greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 2, 2011, at 11:18, Greg KH <greg@kroah.com> wrote:

> On Fri, Sep 02, 2011 at 02:24:36PM +0800, Daniel J Blueman wrote:
>> Hi Luben, Greg, Matthew,
>> 
>> Any plan for reviewing and accepting this patch [1] yet? I'm still
>> seeing the symptoms on USB 3 SATA bridges with linux-3.0+.
> 
> I needed an ack from Matthew before I could take it.
> 
> Matthew?


He acked it already: http://marc.info/?l=linux-kernel&m=128950140420081&w=2

But interestingly enough, it never made it into your tree. 

> 
> 
>> --- [1]
>> 
>> http://www.kerneltrap.com/mailarchive/linux-kernel/2010/11/11/4644097/thread
>> 
>> This patch solves two things:
>> 1) Enables autosense emulation code to correctly
>> interpret descriptor format sense data, and
>> 2) Fixes a bug whereby the autosense emulation
>> code would overwrite descriptor format sense data
>> with SENSE KEY HARDWARE ERROR in fixed format, to
>> incorrectly look like this:
>> 
>> Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  Sense Key :
>> Recovered Error [current] [descriptor]
>> Oct 21 14:11:07 localhost kernel: Descriptor sense data with sense
>> descriptors (in hex):
>> Oct 21 14:11:07 localhost kernel:        72 01 04 1d 00 00 00 0e 09 0c
>> 00 00 00 00 00 00
>> Oct 21 14:11:07 localhost kernel:        00 4f 00 c2 00 50
>> Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d
>> 
>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>> ---
>> drivers/usb/storage/transport.c |   34 +++++++++++++++++++---------------
>> 1 files changed, 19 insertions(+), 15 deletions(-)
>> 
>> diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
>> index 64ec073..cb04664 100644
>> --- a/drivers/usb/storage/transport.c
>> +++ b/drivers/usb/storage/transport.c
>> @@ -691,6 +691,9 @@ void usb_stor_invoke_transport(struct scsi_cmnd
>> *srb, struct us_data *us)
>>        int temp_result;
>>        struct scsi_eh_save ses;
>>        int sense_size = US_SENSE_SIZE;
>> +        struct scsi_sense_hdr sshdr;
>> +        const u8 *scdd;
>> +        u8 fm_ili;
>> 
>>        /* device supports and needs bigger sense buffer */
>>        if (us->fflags & US_FL_SANE_SENSE)
>> @@ -774,32 +777,30 @@ Retry_Sense:
>>            srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
>>        }
>> 
>> +        scsi_normalize_sense(srb->sense_buffer, SCSI_SENSE_BUFFERSIZE,
>> +                     &sshdr);
>> +
>>        US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
>>        US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
>> -              srb->sense_buffer[0],
>> -              srb->sense_buffer[2] & 0xf,
>> -              srb->sense_buffer[12],
>> -              srb->sense_buffer[13]);
>> +              sshdr.response_code, sshdr.sense_key,
>> +              sshdr.asc, sshdr.ascq);
>> #ifdef CONFIG_USB_STORAGE_DEBUG
>> -        usb_stor_show_sense(
>> -              srb->sense_buffer[2] & 0xf,
>> -              srb->sense_buffer[12],
>> -              srb->sense_buffer[13]);
>> +        usb_stor_show_sense(sshdr.sense_key, sshdr.asc, sshdr.ascq);
>> #endif
>> 
>>        /* set the result so the higher layers expect this data */
>>        srb->result = SAM_STAT_CHECK_CONDITION;
>> 
>> +        scdd = scsi_sense_desc_find(srb->sense_buffer,
>> +                        SCSI_SENSE_BUFFERSIZE, 4);
>> +        fm_ili = (scdd ? scdd[3] : srb->sense_buffer[2]) & 0xA0;
>> +
>>        /* We often get empty sense data.  This could indicate that
>>         * everything worked or that there was an unspecified
>>         * problem.  We have to decide which.
>>         */
>> -        if (    /* Filemark 0, ignore EOM, ILI 0, no sense */
>> -                (srb->sense_buffer[2] & 0xaf) == 0 &&
>> -            /* No ASC or ASCQ */
>> -                srb->sense_buffer[12] == 0 &&
>> -                srb->sense_buffer[13] == 0) {
>> -
>> +        if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0 &&
>> +            fm_ili == 0) {
>>            /* If things are really okay, then let's show that.
>>             * Zero out the sense buffer so the higher layers
>>             * won't realize we did an unsolicited auto-sense.
>> @@ -814,7 +815,10 @@ Retry_Sense:
>>             */
>>            } else {
>>                srb->result = DID_ERROR << 16;
>> -                srb->sense_buffer[2] = HARDWARE_ERROR;
>> +                if ((sshdr.response_code & 0x72) == 0x72)
>> +                    srb->sense_buffer[1] = HARDWARE_ERROR;
>> +                else
>> +                    srb->sense_buffer[2] = HARDWARE_ERROR;
>>            }
>>        }
>>    }
>> -- 
>> Daniel J Blueman
