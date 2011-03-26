Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1CZTLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:11:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41888 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1CZTLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hT/0zZLj1D+7rInhAL6xUSynmAKgr6q468EON9xIGm1X586XCIjBYhdIVb0pLoDx2l
         PsPagjPvkdI9RZaZSLDi6hZeh+kwxmm+CxULyVsM3O5uWLXv1Hr4FSJ33LI1es87cZrf
         uGxJcakxctwugr65DsJ3rcu6/8jAUOAOg7tO0=
MIME-Version: 1.0
In-Reply-To: <1301165486.17567.7.camel@Joe-Laptop>
References: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
	<1301156180-12192-2-git-send-email-ralf.thielow@googlemail.com>
	<1301165486.17567.7.camel@Joe-Laptop>
Date: Sat, 26 Mar 2011 20:11:43 +0100
Message-ID: <AANLkTi=dOCmcJ9MA03gtsK5oc4N4FH2thuhMjmv7_T6z@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: keucr: smscsi: Includes missing KERN_
 facility level to printk().
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course, the whole staging directory with "make clean
M=drivers/staging && make M=drivers/staging".
You're right. The "printk" function accept these but it's wrong.

Thanks

2011/3/26 Joe Perches <joe@perches.com>:
> On Sat, 2011-03-26 at 17:16 +0100, Ralf Thielow wrote:
>> Includes missing KERN_ facility level to printk().
> []
>> diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
> []
>> @@ -97,7 +97,7 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
>>       WORD bl_len;
>>       BYTE buf[8];
>>
>> -     printk("SM_SCSI_Read_Capacity\n");
>> +     printk(KERN_DEBUG, "SM_SCSI_Read_Capacity\n");
>
> There should not be a comma between KERN_<level> and format.
>
> Compile tested?
>
>> +     printk(KERN_DEBUG, "bl_len = %x\n", bl_len);
>> +     printk(KERN_DEBUG, "bl_num = %x\n", bl_num);
>
>
>
