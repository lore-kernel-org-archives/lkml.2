Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1I0AFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 20:05:20 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26278 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab1I0AFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 20:05:16 -0400
Message-ID: <4E811338.2030005@dsn.okisemi.com>
Date: Tue, 27 Sep 2011 09:05:12 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qi Wang <qi.wang@intel.com>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        Aaron Smith <aarons@broadcom.com>
Subject: Re: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com> <B6A520E9CD57404AAFC0831E4FB39541A98073AC7E@IRVEXCHCCR02.corp.ad.broadcom.com> <4E7A7DBA.3020406@dsn.okisemi.com> <B6A520E9CD57404AAFC0831E4FB39541A98073AF26@IRVEXCHCCR02.corp.ad.broadcom.com>
In-Reply-To: <B6A520E9CD57404AAFC0831E4FB39541A98073AF26@IRVEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/23 2:49), Jeffrey (Sheng-Hui) Chu wrote:
> The device is BCM20791.  Please contact Aaron Smith (aarons@broadcom.com) for evaluation.
Though googling the device, I can't find the device.
Broadcom website too.

>
> By the way, the existing handling of 10-bit address in the patch you intended to delete does not work.  You'll need to fix that before you can test with the device successfully.
>
> For the write operation, it's a easy fix:
>
> @@ -410,25 +408,16 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
>   	}
>
>   	if (msgs->flags&  I2C_M_TEN) {
> -		addr_2_msb = ((addr&  I2C_MSB_2B_MSK)>>  7);
> +		addr_2_msb = ((addr&  I2C_MSB_2B_MSK)>>  7)&  0x06;
>
>
> For the read operation, static s32 pch_i2c_readbytes(), you'll need to do a write followed by a restart and a read...  please refer to the i2c spec...
>
> Regards,

Thank you for your indication.
We will update this after supporting 10bit access.

Thanks,
tomoya
