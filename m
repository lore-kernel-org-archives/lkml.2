Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2GFJKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:10:30 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29631 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751143Ab2GFJK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:10:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkNAESp9k9bdWOb/2dsb2JhbABFrnsiiBuBB4IYAQEEAScLAQUdIwEFCwsYCRYPCQMCAQIBRQYNAQUCAQGIAgm6PYJBiHiGJgOVN4kmhl2CYQ
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940056355"
Message-ID: <4FF6AA0F.8090400@igalia.com>
Date: Fri, 06 Jul 2012 11:04:15 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/19] Staging: xgifb: Rework conditions in XGI_SetLockRegs().
References: <cover.1341498465.git.magomez@igalia.com> <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com> <20120706065113.GG4462@mwanda>
In-Reply-To: <20120706065113.GG4462@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 05, 2012 at 04:45:58PM +0200, Miguel Gómez wrote:
>> Rework some conditions to reduce indentation and fix style warnings.
>>
>> Signed-off-by: Miguel Gómez <magomez@igalia.com>
>> ---
>>   drivers/staging/xgifb/vb_setmode.c |   29 ++++++++++++-----------------
>>   1 file changed, 12 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
>> index a7ba99f..b439f59 100644
>> --- a/drivers/staging/xgifb/vb_setmode.c
>> +++ b/drivers/staging/xgifb/vb_setmode.c
>> @@ -4039,23 +4039,18 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
>>   	}
>>
>>   	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
>> -		if (pVBInfo->VBType & VB_SIS301LV) {
>> -			if (pVBInfo->TVInfo & TVSetHiVision) {
>> -				tempbx -= 10;
>
> We drop this -= 10 in the final.  It seems accidental.

Nope, it's done on purpose. I've joined 2 conditions that were like this

if (pVBInfo->VBType & VB_SIS301LV) {
	if (pVBInfo->TVInfo & TVSetHiVision) {
		tempbx -= 10;
	} else {
		/* internal stuff */
	}
} else {
	tempbx -= 10;
}

into a single one like this

if ((pVBInfo->VBType & VB_SIS301LV) &&
     !(pVBInfo->TVInfo & TVSetHiVision)) {
	/* internal stuff */
} else {
	tempbx -= 10;
}

That's why one of the else branches has been removed.


-- 
Miguel Gómez
Igalia - http://www.igalia.com


