Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1DSPGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:06:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1DSPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hjsaWLWEtomZBxuujDJ11FNuFrC8CpGBC9p/cPVJI0U77MLlYDTvG1uqxUP/yfRywd
         GBiOFLoCLAX3GFMkwBKUtBVxUUINLOO4R/0SqozxfVcul4flFXogp6M8GRmjn/KVphsi
         oju1Ag7N3xkjM/SZf29tWHU/BHC1ZuUppvYZE=
Message-ID: <4DADA4D8.4080602@gmail.com>
Date: Tue, 19 Apr 2011 17:06:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "'Jiri Slaby'" <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        "'Jean Delvare'" <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 5/7] I2C: eg20t, remove unused variable
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz> <1300870200-24405-5-git-send-email-jslaby@suse.cz> <3DCFFD98C696488F94CB1A74F2998DF9@hacdom.okisemi.com>
In-Reply-To: <3DCFFD98C696488F94CB1A74F2998DF9@hacdom.okisemi.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 11:50 AM, Tomoya MORINAGA wrote:
> Hi Jiri,
> 
> It looks OK.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> 

Hi, will somebody take it or should I resubmit?

> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org 
>> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jiri Slaby
>> Sent: Wednesday, March 23, 2011 5:50 PM
>> To: jirislaby@gmail.com
>> Cc: linux-kernel@vger.kernel.org; Jiri Slaby; Jean Delvare; 
>> linux-i2c@vger.kernel.org
>> Subject: [PATCH 5/7] I2C: eg20t, remove unused variable
>>
>> drivers/i2c/busses/i2c-eg20t.c:684:2: warning: Value stored 
>> to 'msglen' is never read msglen = (pmsg->len) - (subaddrlen + 1);
>> ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Cc: linux-i2c@vger.kernel.org
>> ---
>>  drivers/i2c/busses/i2c-eg20t.c |    8 --------
>>  1 files changed, 0 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-eg20t.c 
>> b/drivers/i2c/busses/i2c-eg20t.c index 878a120..ea73252 100644
>> --- a/drivers/i2c/busses/i2c-eg20t.c
>> +++ b/drivers/i2c/busses/i2c-eg20t.c
>> @@ -651,8 +651,6 @@ static s32 pch_i2c_xfer(struct 
>> i2c_adapter *i2c_adap,
>>  	struct i2c_msg *pmsg;
>>  	u32 i = 0;
>>  	u32 status;
>> -	u32 msglen;
>> -	u32 subaddrlen;
>>  	s32 ret;
>>  
>>  	struct i2c_algo_pch_data *adap = i2c_adap->algo_data; 
>> @@ -676,12 +674,6 @@ static s32 pch_i2c_xfer(struct 
>> i2c_adapter *i2c_adap,
>>  	status = pmsg->flags;
>>  	pch_dbg(adap,
>>  		"After invoking I2C_MODE_SEL :flag= 0x%x\n", status);
>> -	/* calculate sub address length and message length */
>> -	/* these are applicable only for buffer mode */
>> -	subaddrlen = pmsg->buf[0];
>> -	/* calculate actual message length excluding
>> -	 * the sub address fields */
>> -	msglen = (pmsg->len) - (subaddrlen + 1);
>>  	if (status & (I2C_M_RD)) {
>>  		pch_dbg(adap, "invoking pch_i2c_readbytes\n");
>>  		ret = pch_i2c_readbytes(i2c_adap, pmsg, (i + 1 == num),
>> --
>> 1.7.4.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 


-- 
js
