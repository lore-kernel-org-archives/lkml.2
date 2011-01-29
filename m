Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1A2WIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:08:25 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:51535 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1A2WIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:08:24 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Stefan Weil <weil@mail.berlios.de>, linux390@de.ibm.com,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] s390: Fix possibly wrong size in strncmp (smsglucv)
References: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
	<1296336808-2809-2-git-send-email-weil@mail.berlios.de>
	<alpine.LNX.2.00.1101292237220.19392@swampdragon.chaosbits.net>
X-Yow: Do you need any MOUTH-TO-MOUTH resuscitation?
Date: Sat, 29 Jan 2011 23:08:20 +0100
In-Reply-To: <alpine.LNX.2.00.1101292237220.19392@swampdragon.chaosbits.net>
	(Jesper Juhl's message of "Sat, 29 Jan 2011 22:38:31 +0100 (CET)")
Message-ID: <m2mxmjtlbf.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jj@chaosbits.net> writes:

> On Sat, 29 Jan 2011, Stefan Weil wrote:
>
>> This error was reported by cppcheck:
>> drivers/s390/net/smsgiucv.c:63: error: Using sizeof for array given as function argument returns the size of pointer.
>> 
>> Although there is no runtime problem as long as sizeof(u8 *) == 8,
>> this misleading code should get fixed.
>> 
>> Cc: Ursula Braun <ursula.braun@de.ibm.com>
>> Cc: linux390@de.ibm.com
>> Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: linux-s390@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
>> ---
>>  drivers/s390/net/smsgiucv.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/s390/net/smsgiucv.c b/drivers/s390/net/smsgiucv.c
>> index 65e1cf1..207b7d7 100644
>> --- a/drivers/s390/net/smsgiucv.c
>> +++ b/drivers/s390/net/smsgiucv.c
>> @@ -60,7 +60,7 @@ static struct iucv_handler smsg_handler = {
>>  static int smsg_path_pending(struct iucv_path *path, u8 ipvmid[8],
>>  			     u8 ipuser[16])
>>  {
>> -	if (strncmp(ipvmid, "*MSG    ", sizeof(ipvmid)) != 0)
>> +	if (strncmp(ipvmid, "*MSG    ", 8) != 0)
>
> Hmm, shouldn't this really be  ARRAY_SIZE(ipvmid)  ??

ARRAY_SIZE does not work for the same reason why sizeof does not work:
ipvmid is not an array, it's a pointer.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
