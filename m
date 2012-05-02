Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2EBFC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:02:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14966 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2EBFC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:02:58 -0400
X-AuditID: cbfee61b-b7ce2ae00000583e-ed-4fa0bfff453a
Message-id: <4FA0BFFF.8090306@samsung.com>
Date: Wed, 02 May 2012 14:02:55 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        Chiwoong byun <woong.byun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] MFD : add MAX77686 mfd driver
References: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120430091748.GA2460@andi>
In-reply-to: <20120430091748.GA2460@andi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi.

These exported functions will be used in 77686 area only, so there is no
overlap locking.

Thanks.

On 2012-04-30 18:17, Andi Shyti wrote:

> Hi,
> 
>> +	mutex_lock(&max77686->iolock);
>> +	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
>> +	mutex_unlock(&max77686->iolock);
> 
> Is it relly necessay to lock whenever you read/write from/to the
> i2c bus? Considering also that these are exported function,
> someone else may lock here before, so we can have a double
> locking on the same mutex.
> 
> Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


