Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab2BJJUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 04:20:32 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15177 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab2BJJU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 04:20:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 10 Feb 2012 01:20:26 -0800
From: Alok Chauhan <alokc@nvidia.com>
To: Alok Chauhan <alokc@nvidia.com>, Ben Dooks <ben-i2c@fluff.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "bones@secretlab.ca" <bones@secretlab.ca>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "dgreid@google.com" <dgreid@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Feb 2012 14:50:22 +0530
Subject: RE: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Topic: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Index: AczMjswFlL9LJKsmQoCUsX6RILKtcACvas5ABiHcoQA=
Message-ID: <7A0BFCFE3DA5CD47B0FB7984326F201A13689D36EE@BGMAIL01.nvidia.com>
References: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
 <20120106161803.GQ19115@trinity.fluff.org>
 <7A0BFCFE3DA5CD47B0FB7984326F201A134F2CD4F1@BGMAIL01.nvidia.com>
In-Reply-To: <7A0BFCFE3DA5CD47B0FB7984326F201A134F2CD4F1@BGMAIL01.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 26, 2011 at 04:44:41PM +0530, Alok Chauhan wrote:
>> 
> +	/*
> +	 * In NACK error condition resetting of I2C controller happens
> +	 * before STOP condition is properly completed by I2C controller,
> +	 * so wait for 2 clock cycle to complete STOP condition.
> +	 */
> +	if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
> +		udelay(DIV_ROUND_UP(2 * 1000000, i2c_dev->bus_clk_rate));
> +

>Is a delay here good, would it be better to sleep so that some other process can gain cpu time?
>>We mostly used 100 khz i2c clock frequency and delay in that case will be 20 usec. Would it be ok to sleep for such a smaller time? Won't it increase any other overhead?

Please let me know if sleep is better option here instead of waiting.

Thanks
Alok

--
To unsubscribe from this list: send the line "unsubscribe linux-i2c" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
