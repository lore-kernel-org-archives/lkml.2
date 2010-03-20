Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab0CTTVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:21:47 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:47159 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0CTTVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:21:46 -0400
X-SENDER-IP: [83.226.250.190]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhY1AK+9pEtT4vq+PGdsb2JhbACBO4QslWEBAQEBN7xPhH0E
X-IronPort-AV: E=Sophos;i="4.51,279,1267398000"; 
   d="scan'208";a="53662484"
Message-ID: <4BA5204C.9050208@coyote.org>
Date: Sat, 20 Mar 2010 20:21:48 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, gregkh@suse.de, greg@kroah.com,
       penberg@cs.helsinki.fi, pavel@ucw.cz, harvey.harrison@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: reg.c Coding style fixes.
References: <1269098051-6594-1-git-send-email-lindley@coyote.org> <20100320162426.GB28881@bicker>
In-Reply-To: <20100320162426.GB28881@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2010-03-20 17:24, Dan Carpenter wrote:
> On Sat, Mar 20, 2010 at 04:14:11PM +0100, Lars Lindley wrote:
>> I fixed all problems reported by checkpatch.pl except some
>> (a lot of) long lines and some printk:s.
>> I removed "commented away" code and version comments.
>>
> 
> 	[snip]
> 
>> -		msleep(10); // Modify 20051221.1.b
>> -		Wb35Reg_WriteSync( pHwData, 0x03d4, 0xb8 );// REG_ON RF_RSTN on, and
>> -		msleep(10); // Modify 20051221.1.b
> 
> 	You removed this msleep().
> 

Oops! I think I was fooled by the strange comment on the line before..

>> -
>> +	if (pHwData->phy_type <= RF_MAXIM_V1)
>> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xffffff38);
>> +	else {
>> +		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
>> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
>> +		msleep(10);
>> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and msleep(10); */
> 
> In the new version it's commented out.                                             ^^^^^^^^^^^^
> 
> I used a program to try verify that only white space changed.
> http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/01012.html
> 
> Then when it failed I grovelled through to find what changed.
> 
> Actually my tool complained about removed parenthesis as well.  I think 
> this patch only removes one set of parenthesis.  Please don't do that.  
> With a patch this size, it's nice to be able to use tools to verify that 
> it doesn't change anything, instead of checking it by hand. Tabs, spaces
> and newlines only, please.
> 
Point taken. Will keep it in mind from now on..

> Obviously in the next patch you can send the one liner that remove the
> parenthesis.  We can eyeball one liners quite quickly.
> 
> regards,
> dan carpenter
> 


Here's a patch to fix my screw up :)
Now the .o doesn't differ before and after..


[PATCH] staging: winbond: reg.c Fix accidental commenting of msleep(10)

I accidentaly commented out msleep() in one place.
This applies after previous patch:
Message-Id: <1269098051-6594-1-git-send-email-lindley@coyote.org>

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/reg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 2bddf8f..d9a8128 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -890,7 +890,8 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
 		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
 		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
 		msleep(10);
-		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and msleep(10); */
+		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and */
+		msleep(10);
 		ltmp = 0x4968;
 		if ((pHwData->phy_type == RF_WB_242) ||
 			(RF_WB_242_1 == pHwData->phy_type))
-- 
1.7.0.2
