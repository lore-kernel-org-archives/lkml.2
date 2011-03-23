Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1CWKug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:50:36 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:20160 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271Ab1CWKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:50:34 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Jiri Slaby'" <jslaby@suse.cz>, <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "'Jean Delvare'" <khali@linux-fr.org>,
        <linux-i2c@vger.kernel.org>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz> <1300870200-24405-5-git-send-email-jslaby@suse.cz>
Subject: RE: [PATCH 5/7] I2C: eg20t, remove unused variable
Date: Wed, 23 Mar 2011 19:50:31 +0900
Message-ID: <3DCFFD98C696488F94CB1A74F2998DF9@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvpN4jupOcNFvn8QA600wAgoKuWFAAD+Jhw
In-Reply-To: <1300870200-24405-5-git-send-email-jslaby@suse.cz>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

It looks OK.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> 

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jiri Slaby
> Sent: Wednesday, March 23, 2011 5:50 PM
> To: jirislaby@gmail.com
> Cc: linux-kernel@vger.kernel.org; Jiri Slaby; Jean Delvare; 
> linux-i2c@vger.kernel.org
> Subject: [PATCH 5/7] I2C: eg20t, remove unused variable
> 
> drivers/i2c/busses/i2c-eg20t.c:684:2: warning: Value stored 
> to 'msglen' is never read msglen = (pmsg->len) - (subaddrlen + 1);
> ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: linux-i2c@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-eg20t.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-eg20t.c 
> b/drivers/i2c/busses/i2c-eg20t.c index 878a120..ea73252 100644
> --- a/drivers/i2c/busses/i2c-eg20t.c
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -651,8 +651,6 @@ static s32 pch_i2c_xfer(struct 
> i2c_adapter *i2c_adap,
>  	struct i2c_msg *pmsg;
>  	u32 i = 0;
>  	u32 status;
> -	u32 msglen;
> -	u32 subaddrlen;
>  	s32 ret;
>  
>  	struct i2c_algo_pch_data *adap = i2c_adap->algo_data; 
> @@ -676,12 +674,6 @@ static s32 pch_i2c_xfer(struct 
> i2c_adapter *i2c_adap,
>  	status = pmsg->flags;
>  	pch_dbg(adap,
>  		"After invoking I2C_MODE_SEL :flag= 0x%x\n", status);
> -	/* calculate sub address length and message length */
> -	/* these are applicable only for buffer mode */
> -	subaddrlen = pmsg->buf[0];
> -	/* calculate actual message length excluding
> -	 * the sub address fields */
> -	msglen = (pmsg->len) - (subaddrlen + 1);
>  	if (status & (I2C_M_RD)) {
>  		pch_dbg(adap, "invoking pch_i2c_readbytes\n");
>  		ret = pch_i2c_readbytes(i2c_adap, pmsg, (i + 1 == num),
> --
> 1.7.4.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

